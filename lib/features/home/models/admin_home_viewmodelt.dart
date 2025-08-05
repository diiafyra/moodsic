import 'dart:async';
import 'dart:developer' as developer; // Thêm để log debug
import 'package:flutter/material.dart';
import 'package:moodsic/core/services/firestore/firestore_service.dart';
import 'package:moodsic/core/utils/validators.dart';
import 'package:moodsic/data/models/user.dart';
import 'package:moodsic/data/repositories/recommendation_repository.dart';
import 'package:moodsic/data/repositories/user_repository.dart';
import 'package:moodsic/domains/usecases/fetch_recent_users.dart';
import 'package:moodsic/domains/usecases/fetch_total_requests.dart';
import 'package:moodsic/domains/usecases/fetch_total_user.dart';
import 'package:moodsic/features/survey/widgets/artist_selection_widget.dart'; // Thêm để sử dụng GetIt

class AdminHomeViewModel {
  final TextEditingController _searchController = TextEditingController();
  final StreamController<Map<String, dynamic>> _dashboardController =
      StreamController.broadcast();
  final FetchTotalUsers _fetchTotalUsers;
  final FetchTotalRequests _fetchTotalRequests;
  final FetchRecentUsers _fetchRecentUsers;

  int _totalUsers = 0;
  int _totalRequests = 0;
  List<UserModel> _recentUsers = [];
  String _searchQuery = '';

  AdminHomeViewModel()
    : _fetchTotalUsers = FetchTotalUsers(
        UserRepository(getIt<FirestoreService>()),
      ),
      _fetchTotalRequests = FetchTotalRequests(
        RecommendationRepository(getIt<FirestoreService>()),
      ),
      _fetchRecentUsers = FetchRecentUsers(
        UserRepository(getIt<FirestoreService>()),
      ) {
    developer.log('AdminHomeViewModel initialized', name: 'AdminHomeViewModel');
    _searchController.addListener(() {
      updateSearchQuery(_searchController.text);
    });
    _initializeDashboardData(); // Khởi tạo dữ liệu khi view model được tạo
  }

  TextEditingController get searchController => _searchController;
  Stream<Map<String, dynamic>> get dashboardStream =>
      _dashboardController.stream;
  int get totalUsers => _totalUsers;
  int get totalRequests => _totalRequests;
  List<UserModel> get filteredUsers =>
      _recentUsers.where((user) {
        return Validators.isValidSearchQuery(_searchQuery, user.displayName) ||
            Validators.isValidSearchQuery(_searchQuery, user.email);
      }).toList();

  Future<void> _initializeDashboardData() async {
    await fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      developer.log('Fetching dashboard data', name: 'AdminHomeViewModel');
      _totalUsers = await _fetchTotalUsers.execute();
      _totalRequests = await _fetchTotalRequests.execute();
      _recentUsers = await _fetchRecentUsers.execute(5);
      developer.log(
        'Dashboard data fetched - Total Users: $_totalUsers, Total Requests: $_totalRequests, Recent Users: ${_recentUsers.length}',
        name: 'AdminHomeViewModel',
      );
      _dashboardController.add({
        'totalUsers': _totalUsers,
        'totalRequests': _totalRequests,
        'recentUsers': _recentUsers,
      });
    } catch (e) {
      developer.log(
        'Error fetching dashboard data: $e',
        name: 'AdminHomeViewModel',
        error: e,
      );
      _dashboardController.addError('Failed to fetch dashboard data: $e');
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    developer.log(
      'Search query updated: $_searchQuery',
      name: 'AdminHomeViewModel',
    );
    _dashboardController.add({
      'totalUsers': _totalUsers,
      'totalRequests': _totalRequests,
      'recentUsers': _recentUsers,
    });
  }

  void dispose() {
    _searchController.dispose();
    _dashboardController.close();
    developer.log('AdminHomeViewModel disposed', name: 'AdminHomeViewModel');
  }
}
