import 'package:flutter/material.dart';
import 'package:moodsic/shared/states/auth_provider.dart'; // Thêm import
import 'package:moodsic/core/widgets/stat_card.dart';
import 'package:moodsic/features/home/models/admin_home_viewmodelt.dart';
import 'package:moodsic/features/home/widgets/user_list.dart';
import 'package:provider/provider.dart'; // Thêm import cho Provider
import 'package:syncfusion_flutter_charts/charts.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final AdminHomeViewModel _viewModel = AdminHomeViewModel();

  late List<_ChartData> chartData;

  @override
  void initState() {
    super.initState();
    // Log user từ CAuthProvider
    final authProvider = Provider.of<CAuthProvider>(context, listen: false);
    print('[AdminHomePage] User: ${authProvider.user}');
    print('[AdminHomePage] User UID: ${authProvider.user?.uid}');
    print('[AdminHomePage] Role: ${authProvider.role}');
    print('[AdminHomePage] Is Loading: ${authProvider.isLoading}');

    _viewModel.fetchDashboardData();
  }

  List<_ChartData> _createChartData() {
    return [
      _ChartData('Users', _viewModel.totalUsers),
      _ChartData('Requests', _viewModel.totalRequests),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _viewModel.searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search users by name or email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: (value) => _viewModel.updateSearchQuery(value),
              ),
              const SizedBox(height: 20),
              StreamBuilder(
                stream: _viewModel.dashboardStream,
                builder: (
                  context,
                  AsyncSnapshot<Map<String, dynamic>> snapshot,
                ) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    // Log lỗi từ StreamBuilder
                    print(
                      '[AdminHomePage] StreamBuilder Error: ${snapshot.error}',
                    );
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  chartData = _createChartData();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          StatCard(
                            title: 'Total Users',
                            value: _viewModel.totalUsers.toString(),
                            icon: Icons.people,
                          ),
                          StatCard(
                            title: 'Total Requests',
                            value: _viewModel.totalRequests.toString(),
                            icon: Icons.list_alt,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Overview Chart',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 200,
                        child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <CartesianSeries<_ChartData, String>>[
                            ColumnSeries<_ChartData, String>(
                              dataSource: chartData,
                              xValueMapper: (_ChartData data, _) => data.label,
                              yValueMapper: (_ChartData data, _) => data.value,
                              name: 'Stats',
                              dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                              ),
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Recent Users',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      UserList(
                        users: _viewModel.filteredUsers,
                        onUserTap: (user) {
                          // Xử lý khi nhấn vào user
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}

class _ChartData {
  final String label;
  final int value;

  _ChartData(this.label, this.value);
}
