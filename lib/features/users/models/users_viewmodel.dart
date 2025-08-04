import 'dart:async';
import 'dart:developer' as developer; // Thêm để log debug
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moodsic/core/services/firestore/firestore_service.dart';
import 'package:moodsic/core/utils/validators.dart';
import 'package:moodsic/data/models/user.dart';
import 'package:moodsic/data/repositories/user_repository.dart';
import 'package:moodsic/domains/usecases/delete_user.dart';
import 'package:moodsic/domains/usecases/fetch_all_users.dart';
import 'package:moodsic/features/survey/widgets/artist_selection_widget.dart';
import 'package:moodsic/routes/route_names.dart';
import 'package:get_it/get_it.dart'; // Thêm để sử dụng GetIt

class UsersViewModel {
  final TextEditingController _searchController = TextEditingController();
  final StreamController<List<UserModel>> _usersController =
      StreamController.broadcast();
  final FetchAllUsers _fetchAllUsers;
  final DeleteUser _deleteUser;

  List<UserModel> _allUsers = [];
  String _searchQuery = '';
  String _selectedProvider = 'All';
  int _currentPage = 1;
  final int _pageSize = 10;
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;

  UsersViewModel()
    : _fetchAllUsers = FetchAllUsers(UserRepository(getIt<FirestoreService>())),
      _deleteUser = DeleteUser(UserRepository(getIt<FirestoreService>())) {
    developer.log('UsersViewModel: Initialized', name: 'UsersViewModel');
    _searchController.addListener(() {
      updateSearchQuery(_searchController.text);
    });
    _initializeUsersData(); // Khởi tạo dữ liệu khi view model được tạo
  }

  TextEditingController get searchController => _searchController;
  Stream<List<UserModel>> get usersStream => _usersController.stream;
  String get selectedProvider => _selectedProvider;
  int get currentPage => _currentPage;
  bool get hasMore => _hasMore;

  Future<void> _initializeUsersData() async {
    await fetchUsers();
  }

  Future<void> fetchUsers({
    bool isNext = false,
    bool isPrevious = false,
  }) async {
    developer.log(
      'UsersViewModel: Fetching users, page: $_currentPage, isNext: $isNext, isPrevious: $isPrevious',
      name: 'UsersViewModel',
    );
    try {
      if (isPrevious && _currentPage > 1) {
        developer.log(
          'UsersViewModel: Moving to previous page',
          name: 'UsersViewModel',
        );
        _currentPage--;
        _lastDocument = null;
        _allUsers.clear();
        for (int i = 1; i < _currentPage; i++) {
          final result = await _fetchAllUsers.executePaginated(
            _pageSize,
            _lastDocument,
          );
          _allUsers.addAll(result['users'] as List<UserModel>);
          _lastDocument = result['lastDocument'] as DocumentSnapshot?;
          developer.log(
            'UsersViewModel: Loaded page $i, users: ${_allUsers.length}, lastDocument: $_lastDocument',
            name: 'UsersViewModel',
          );
        }
      } else if (isNext && _hasMore) {
        developer.log(
          'UsersViewModel: Moving to next page',
          name: 'UsersViewModel',
        );
        _currentPage++;
      }

      final result = await _fetchAllUsers.executePaginated(
        _pageSize,
        _lastDocument,
      );
      final newUsers = result['users'] as List<UserModel>;
      _lastDocument = result['lastDocument'] as DocumentSnapshot?;
      _hasMore = newUsers.length == _pageSize;

      developer.log(
        'UsersViewModel: Fetched ${newUsers.length} users, hasMore: $_hasMore',
        name: 'UsersViewModel',
      );

      if (!isPrevious) {
        _allUsers.addAll(newUsers);
      }

      _updateUsersStream();
    } catch (e, stackTrace) {
      developer.log(
        'UsersViewModel: Error fetching users: $e',
        name: 'UsersViewModel',
        error: e,
        stackTrace: stackTrace,
      );
      _usersController.addError(e);
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    developer.log(
      'UsersViewModel: Search query updated to $_searchQuery',
      name: 'UsersViewModel',
    );
    _updateUsersStream();
  }

  void updateProviderFilter(String provider) {
    _selectedProvider = provider;
    developer.log(
      'UsersViewModel: Provider filter updated to $_selectedProvider',
      name: 'UsersViewModel',
    );
    _updateUsersStream();
  }

  void _updateUsersStream() {
    final filteredUsers =
        _allUsers.where((user) {
          final matchesSearch =
              _searchQuery.isEmpty ||
              Validators.isValidSearchQuery(_searchQuery, user.displayName) ||
              Validators.isValidSearchQuery(_searchQuery, user.email);
          final matchesProvider =
              _selectedProvider == 'All' ||
              user.provider.toLowerCase() == _selectedProvider.toLowerCase();
          return matchesSearch && matchesProvider;
        }).toList();
    developer.log(
      'UsersViewModel: Emitting ${filteredUsers.length} filtered users',
      name: 'UsersViewModel',
    );
    _usersController.add(filteredUsers);
  }

  void navigateToUserDetail(BuildContext context, String uid) {
    developer.log(
      'UsersViewModel: Navigating to user detail for UID: $uid',
      name: 'UsersViewModel',
    );
    context.go(RouteNames.userDetail.replaceFirst(':uid', uid));
  }

  Future<void> deleteUser(BuildContext context, String uid) async {
    developer.log(
      'UsersViewModel: Attempting to delete user $uid',
      name: 'UsersViewModel',
    );
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text('Are you sure you want to delete this user?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
    if (confirmed == true) {
      try {
        await _deleteUser.execute(uid);
        _allUsers.removeWhere((user) => user.uid == uid);
        developer.log(
          'UsersViewModel: User $uid deleted successfully',
          name: 'UsersViewModel',
        );
        _updateUsersStream();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User deleted successfully')),
        );
      } catch (e) {
        developer.log(
          'UsersViewModel: Error deleting user: $e',
          name: 'UsersViewModel',
          error: e,
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error deleting user: $e')));
      }
    }
  }

  void dispose() {
    developer.log('UsersViewModel: Disposing', name: 'UsersViewModel');
    _searchController.dispose();
    _usersController.close();
  }
}
