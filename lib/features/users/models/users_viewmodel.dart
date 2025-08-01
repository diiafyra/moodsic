import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moodsic/core/services/firestore_service.dart';
import 'package:moodsic/core/utils/validators.dart';
import 'package:moodsic/data/models/user.dart';
import 'package:moodsic/data/repositories/user_repository.dart';
import 'package:moodsic/domains/usecases/delete_user.dart';
import 'package:moodsic/domains/usecases/fetch_all_users.dart';
import 'package:moodsic/routes/route_names.dart';

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
    : _fetchAllUsers = FetchAllUsers(UserRepository(FirestoreService())),
      _deleteUser = DeleteUser(UserRepository(FirestoreService())) {
    _searchController.addListener(() {
      updateSearchQuery(_searchController.text);
    });
    print('UsersViewModel: Initialized');
  }

  TextEditingController get searchController => _searchController;
  Stream<List<UserModel>> get usersStream => _usersController.stream;
  String get selectedProvider => _selectedProvider;
  int get currentPage => _currentPage;
  bool get hasMore => _hasMore;

  Future<void> fetchUsers({
    bool isNext = false,
    bool isPrevious = false,
  }) async {
    print(
      'UsersViewModel: Fetching users, page: $_currentPage, isNext: $isNext, isPrevious: $isPrevious',
    );
    try {
      if (isPrevious && _currentPage > 1) {
        print('UsersViewModel: Moving to previous page');
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
          print(
            'UsersViewModel: Loaded page $i, users: ${_allUsers.length}, lastDocument: $_lastDocument',
          );
        }
      } else if (isNext && _hasMore) {
        print('UsersViewModel: Moving to next page');
        _currentPage++;
      }

      final result = await _fetchAllUsers.executePaginated(
        _pageSize,
        _lastDocument,
      );
      final newUsers = result['users'] as List<UserModel>;
      _lastDocument = result['lastDocument'] as DocumentSnapshot?;
      _hasMore = newUsers.length == _pageSize;

      print(
        'UsersViewModel: Fetched ${newUsers.length} users, hasMore: $_hasMore',
      );

      if (!isPrevious) {
        _allUsers.addAll(newUsers);
      }

      _updateUsersStream();
    } catch (e, stackTrace) {
      print('UsersViewModel: Error fetching users: $e');
      print('Stack trace: $stackTrace');
      _usersController.addError(e);
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    print('UsersViewModel: Search query updated to $_searchQuery');
    _updateUsersStream();
  }

  void updateProviderFilter(String provider) {
    _selectedProvider = provider;
    print('UsersViewModel: Provider filter updated to $_selectedProvider');
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
    print('UsersViewModel: Emitting ${filteredUsers.length} filtered users');
    _usersController.add(filteredUsers);
  }

  void navigateToUserDetail(BuildContext context, String uid) {
    print('UsersViewModel: Navigating to user detail for UID: $uid');
    context.go(RouteNames.userDetail.replaceFirst(':uid', uid));
  }

  Future<void> deleteUser(BuildContext context, String uid) async {
    print('UsersViewModel: Attempting to delete user $uid');
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
        print('UsersViewModel: User $uid deleted successfully');
        _updateUsersStream();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User deleted successfully')),
        );
      } catch (e) {
        print('UsersViewModel: Error deleting user: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error deleting user: $e')));
      }
    }
  }

  void dispose() {
    print('UsersViewModel: Disposing');
    _searchController.dispose();
    _usersController.close();
  }
}
