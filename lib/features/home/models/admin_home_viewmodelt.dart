import 'dart:async';
import 'package:flutter/material.dart';
import 'package:moodsic/core/services/firestore_service.dart';
import 'package:moodsic/core/utils/validators.dart';
import 'package:moodsic/data/models/user.dart';
import 'package:moodsic/data/repositories/RecommendationRepository.dart';
import 'package:moodsic/data/repositories/user_repository.dart';
import 'package:moodsic/domains/usecases/fetch_recent_users.dart';
import 'package:moodsic/domains/usecases/fetch_total_requests.dart';
import 'package:moodsic/domains/usecases/fetch_total_user.dart';

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
    : _fetchTotalUsers = FetchTotalUsers(UserRepository(FirestoreService())),
      _fetchTotalRequests = FetchTotalRequests(
        RecommendationRepository(FirestoreService()),
      ),
      _fetchRecentUsers = FetchRecentUsers(UserRepository(FirestoreService())) {
    _searchController.addListener(() {
      updateSearchQuery(_searchController.text);
    });
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

  Future<void> fetchDashboardData() async {
    try {
      _totalUsers = await _fetchTotalUsers.execute();
      _totalRequests = await _fetchTotalRequests.execute();
      _recentUsers = await _fetchRecentUsers.execute(5);
      _dashboardController.add({
        'totalUsers': _totalUsers,
        'totalRequests': _totalRequests,
        'recentUsers': _recentUsers,
      });
    } catch (e) {
      print('Error fetching dashboard data: $e');
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _dashboardController.add({
      'totalUsers': _totalUsers,
      'totalRequests': _totalRequests,
      'recentUsers': _recentUsers,
    });
  }

  void dispose() {
    _searchController.dispose();
    _dashboardController.close();
  }
}
