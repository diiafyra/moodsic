import 'dart:async';
import 'dart:developer' as developer;
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
import 'package:moodsic/features/users/pages/user_detail_page.dart';
import 'package:moodsic/routes/route_names.dart';
import 'package:get_it/get_it.dart';

class UsersViewModel {
  final TextEditingController _searchController = TextEditingController();
  final StreamController<List<UserModel>> _usersController =
      StreamController.broadcast();
  final FetchAllUsers _fetchAllUsers;
  final DeleteUser _deleteUser;

  // Raw data từ Firestore (không filter)
  List<UserModel> _rawUsers = [];

  // Filter parameters
  String _searchQuery = '';
  String _selectedProvider = 'All';

  // Pagination parameters
  int _currentPage = 1;
  final int _pageSize = 10;
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;
  bool _isLoading = false;

  UsersViewModel()
    : _fetchAllUsers = FetchAllUsers(UserRepository(getIt<FirestoreService>())),
      _deleteUser = DeleteUser(UserRepository(getIt<FirestoreService>())) {
    developer.log('UsersViewModel: Initialized', name: 'UsersViewModel');
    _searchController.addListener(() {
      _onSearchChanged(_searchController.text);
    });
  }

  // Getters
  TextEditingController get searchController => _searchController;
  Stream<List<UserModel>> get usersStream => _usersController.stream;
  String get selectedProvider => _selectedProvider;
  int get currentPage => _currentPage;
  bool get hasMore => _hasMore;
  bool get isLoading => _isLoading;

  // Khởi tạo dữ liệu ban đầu - giữ tên method cũ để không break UI
  Future<void> fetchUsers({
    bool isNext = false,
    bool isPrevious = false,
  }) async {
    if (isPrevious) {
      await loadPreviousPage();
    } else if (isNext) {
      await loadNextPage();
    } else {
      await _fetchUsersFromFirestore();
    }
  }

  // Method mới để khởi tạo
  Future<void> initialize() async {
    await _fetchUsersFromFirestore();
  }

  // Fetch users từ Firestore với pagination
  Future<void> _fetchUsersFromFirestore({bool isNext = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    developer.log(
      'UsersViewModel: Fetching users from Firestore, page: $_currentPage, isNext: $isNext',
      name: 'UsersViewModel',
    );

    try {
      final result = await _fetchAllUsers.executePaginated(
        _pageSize,
        isNext ? _lastDocument : null,
      );

      final newUsers = result['users'] as List<UserModel>;
      _lastDocument = result['lastDocument'] as DocumentSnapshot?;
      _hasMore = newUsers.length == _pageSize;

      if (isNext) {
        _rawUsers.addAll(newUsers);
        _currentPage++;
      } else {
        // Reset for first page
        _rawUsers = newUsers;
        _currentPage = 1;
      }

      developer.log(
        'UsersViewModel: Fetched ${newUsers.length} users, total: ${_rawUsers.length}, hasMore: $_hasMore',
        name: 'UsersViewModel',
      );

      _applyFiltersAndEmit();
    } catch (e, stackTrace) {
      developer.log(
        'UsersViewModel: Error fetching users: $e',
        name: 'UsersViewModel',
        error: e,
        stackTrace: stackTrace,
      );
      _usersController.addError(e);
    } finally {
      _isLoading = false;
    }
  }

  // Load next page
  Future<void> loadNextPage() async {
    if (!_hasMore || _isLoading) return;
    await _fetchUsersFromFirestore(isNext: true);
  }

  // Load previous page (reset to first page for simplicity)
  Future<void> loadPreviousPage() async {
    if (_currentPage <= 1 || _isLoading) return;

    // For simplicity, reset to first page
    // In a real app, you might want to implement bidirectional pagination
    _lastDocument = null;
    await _fetchUsersFromFirestore();
  }

  // Refresh data
  Future<void> refresh() async {
    _lastDocument = null;
    _currentPage = 1;
    _hasMore = true;
    await _fetchUsersFromFirestore();
  }

  // Handle search query change với debouncing
  Timer? _searchDebounce;
  void _onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      updateSearchQuery(query);
    });
  }

  // Update search query
  void updateSearchQuery(String query) {
    if (_searchQuery == query) return;

    _searchQuery = query.trim();
    developer.log(
      'UsersViewModel: Search query updated to "$_searchQuery"',
      name: 'UsersViewModel',
    );
    _applyFiltersAndEmit();
  }

  // Update provider filter
  void updateProviderFilter(String provider) {
    if (_selectedProvider == provider) return;

    _selectedProvider = provider;
    developer.log(
      'UsersViewModel: Provider filter updated to "$_selectedProvider"',
      name: 'UsersViewModel',
    );
    _applyFiltersAndEmit();
  }

  // Apply all filters and emit filtered data
  void _applyFiltersAndEmit() {
    List<UserModel> filteredUsers = _rawUsers;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filteredUsers =
          filteredUsers.where((user) {
            final searchLower = _searchQuery.toLowerCase();
            final displayNameMatch = user.displayName.toLowerCase().contains(
              searchLower,
            );
            final emailMatch = user.email.toLowerCase().contains(searchLower);
            return displayNameMatch || emailMatch;
          }).toList();
    }

    // Apply provider filter
    if (_selectedProvider != 'All') {
      filteredUsers =
          filteredUsers.where((user) {
            return user.provider.toLowerCase() ==
                _selectedProvider.toLowerCase();
          }).toList();
    }

    developer.log(
      'UsersViewModel: Emitting ${filteredUsers.length} filtered users (from ${_rawUsers.length} raw users)',
      name: 'UsersViewModel',
    );

    _usersController.add(filteredUsers);
  }

  // Navigate to user detail
  void navigateToUserDetail(BuildContext context, String uid) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserDetailPage(uid: uid)),
    );
  }

  // Delete user
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

        // Remove from local data
        _rawUsers.removeWhere((user) => user.uid == uid);

        developer.log(
          'UsersViewModel: User $uid deleted successfully',
          name: 'UsersViewModel',
        );

        _applyFiltersAndEmit();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User deleted successfully')),
          );
        }
      } catch (e) {
        developer.log(
          'UsersViewModel: Error deleting user: $e',
          name: 'UsersViewModel',
          error: e,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error deleting user: $e')));
        }
      }
    }
  }

  // Get available providers for dropdown
  List<String> getAvailableProviders() {
    final providers = _rawUsers.map((user) => user.provider).toSet().toList();
    providers.sort();
    return ['All', ...providers];
  }

  // Dispose resources
  void dispose() {
    developer.log('UsersViewModel: Disposing', name: 'UsersViewModel');
    _searchDebounce?.cancel();
    _searchController.dispose();
    _usersController.close();
  }
}
