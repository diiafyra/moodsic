import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moodsic/core/config/theme/app_colors.dart';

// Import các model và service
import 'package:moodsic/features/recommendation_analytics_page/Models/recommendation_log_firetore.dart';
import 'package:moodsic/core/services/firestore/firestore_service.dart';

class RecommendationStatsScreen extends StatefulWidget {
  const RecommendationStatsScreen({Key? key}) : super(key: key);

  @override
  State<RecommendationStatsScreen> createState() =>
      _RecommendationStatsScreenState();
}

class _RecommendationStatsScreenState extends State<RecommendationStatsScreen> {
  String selectedTimeRange = '7 days';

  // Inject FirestoreService thông qua GetIt
  final FirestoreService _firestoreService = GetIt.instance<FirestoreService>();

  // State để lưu stats data
  Map<String, dynamic>? _statsData;
  List<RecommendationLogFirestore>? _filteredLogs;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Tính toán date range dựa trên selected time range
      final dateRange = _getDateRange(selectedTimeRange);

      // Lấy logs theo time range
      final logs = await _firestoreService
          .getUserRecommendationLogFirestoresByTimeRange(
            startDate: dateRange['start']!,
            endDate: dateRange['end']!,
          );

      // Lấy stats
      final stats = await _firestoreService.getRecommendationLogFirestoreStats(
        startDate: dateRange['start'],
        endDate: dateRange['end'],
      );

      setState(() {
        _filteredLogs = logs;
        _statsData = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Map<String, DateTime> _getDateRange(String timeRange) {
    final now = DateTime.now();
    DateTime startDate;

    switch (timeRange) {
      case '24 hours':
        startDate = now.subtract(const Duration(days: 1));
        break;
      case '7 days':
        startDate = now.subtract(const Duration(days: 7));
        break;
      case '30 days':
        startDate = now.subtract(const Duration(days: 30));
        break;
      case '3 months':
        startDate = now.subtract(const Duration(days: 90));
        break;
      default:
        startDate = now.subtract(const Duration(days: 7));
    }

    return {'start': startDate, 'end': now};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.oceanBlue50,
      appBar: AppBar(
        title: const Text(
          'Recommendation Analytics',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.oceanBlue900,
          ),
        ),

        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<String>(
              value: selectedTimeRange,
              underline: Container(),
              style: TextStyle(
                color: AppColors.oceanBlue700,
                fontWeight: FontWeight.w500,
              ),
              items:
                  ['24 hours', '7 days', '30 days', '3 months'].map((
                    String value,
                  ) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null && newValue != selectedTimeRange) {
                  setState(() {
                    selectedTimeRange = newValue;
                  });
                  _loadData(); // Reload data when time range changes
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _firestoreService.debugRecommendationLogs();
              _firestoreService.debugRecommendationStats();
            },
            child: const Text('In recommendation logs & stats'),
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: AppColors.oceanBlue500),
              )
              : _errorMessage != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.brickRed400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading data',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.charcoal600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage!,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.charcoal500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.oceanBlue500,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
              : RefreshIndicator(
                onRefresh: _loadData,
                color: AppColors.oceanBlue500,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Overview Cards
                      _buildOverviewCards(),
                      const SizedBox(height: 24),

                      // Charts Section
                      _buildChartsSection(),
                      const SizedBox(height: 24),

                      // Recent Recommendations
                      _buildRecentRecommendations(),
                      const SizedBox(height: 24),

                      // Mood Analysis
                      _buildMoodAnalysis(),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildOverviewCards() {
    if (_statsData == null) return const SizedBox.shrink();

    final stats = _statsData!;
    final totalRequests = stats['totalRequests'] as int? ?? 0;
    final todayRequests = stats['todayRequests'] as int? ?? 0;
    final avgPlaylistsPerRequest =
        stats['avgPlaylistsPerRequest'] as double? ?? 0.0;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatsCard(
          'Total Requests',
          totalRequests.toString(),
          Icons.analytics_outlined,
          AppColors.oceanBlue500,
        ),
        _buildStatsCard(
          'Today\'s Requests',
          todayRequests.toString(),
          Icons.today_outlined,
          AppColors.primary500,
        ),
        _buildStatsCard(
          'Avg Playlists',
          avgPlaylistsPerRequest.toStringAsFixed(1),
          Icons.playlist_play_outlined,
          AppColors.indigoNight500,
        ),
        _buildStatsCard(
          'Active Users',
          '1', // Single user for current user stats
          Icons.people_outline,
          AppColors.brickRed500,
        ),
      ],
    );
  }

  Widget _buildStatsCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppColors.charcoal600,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(icon, color: color, size: 24),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              color: AppColors.charcoal900,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Request Trends ($selectedTimeRange)',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.charcoal900,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: _buildLineChart(),
        ),
      ],
    );
  }

  Widget _buildLineChart() {
    if (_statsData == null) {
      return const Center(child: Text('No data available'));
    }

    final dailyRequests =
        _statsData!['dailyRequests'] as Map<String, int>? ?? {};

    if (dailyRequests.isEmpty) {
      return Center(
        child: Text(
          'No requests in the selected time range',
          style: TextStyle(color: AppColors.charcoal600, fontSize: 16),
        ),
      );
    }

    final spots =
        dailyRequests.entries.map((entry) {
          final index = dailyRequests.keys.toList().indexOf(entry.key);
          return FlSpot(index.toDouble(), entry.value.toDouble());
        }).toList();

    final maxY =
        dailyRequests.values.isEmpty
            ? 10.0
            : dailyRequests.values.reduce((a, b) => a > b ? a : b).toDouble() +
                1;

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: maxY,
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: false,
          horizontalInterval: maxY > 10 ? (maxY / 5).ceilToDouble() : 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: AppColors.charcoal200, strokeWidth: 0.5);
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: maxY > 10 ? (maxY / 5).ceilToDouble() : 1,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(color: AppColors.charcoal600, fontSize: 12),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < dailyRequests.keys.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      dailyRequests.keys.elementAt(index),
                      style: TextStyle(
                        color: AppColors.charcoal600,
                        fontSize: 12,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.oceanBlue500,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.oceanBlue500,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.oceanBlue500.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentRecommendations() {
    if (_statsData == null) return const SizedBox.shrink();

    final recentLogs =
        (_statsData!['recentLogs'] as List<RecommendationLogFirestore>?) ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Recommendations',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.charcoal900,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child:
              recentLogs.isEmpty
                  ? Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.music_note_outlined,
                            size: 48,
                            color: AppColors.charcoal400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No recommendations yet',
                            style: TextStyle(
                              color: AppColors.charcoal600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recentLogs.length,
                    separatorBuilder:
                        (context, index) =>
                            Divider(color: AppColors.charcoal200, height: 1),
                    itemBuilder: (context, index) {
                      final log = recentLogs[index];
                      return _buildRecommendationTile(log);
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildRecommendationTile(RecommendationLogFirestore log) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.oceanBlue100,
                ),
                child:
                    log.imageUrl.isNotEmpty
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            log.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.music_note,
                                color: AppColors.oceanBlue500,
                              );
                            },
                          ),
                        )
                        : Icon(Icons.music_note, color: AppColors.oceanBlue500),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${log.playlists.length} playlists recommended',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.charcoal900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTimestamp(log.timestamp),
                      style: TextStyle(
                        color: AppColors.charcoal600,
                        fontSize: 12,
                      ),
                    ),
                    if (log.moodText.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        '"${log.moodText}"',
                        style: TextStyle(
                          color: AppColors.charcoal500,
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getMoodColorByLabel(log.moodLabel),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  log.moodLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (log.keywords.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children:
                  log.keywords.take(5).map((keyword) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        keyword,
                        style: TextStyle(
                          color: AppColors.primary700,
                          fontSize: 10,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMoodAnalysis() {
    if (_statsData == null) return const SizedBox.shrink();

    final moodDistribution =
        _statsData!['moodDistribution'] as Map<String, int>? ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mood Distribution',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.charcoal900,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child:
              moodDistribution.isEmpty
                  ? SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(
                        'No mood data available',
                        style: TextStyle(
                          color: AppColors.charcoal600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                  : _buildMoodChart(moodDistribution),
        ),
      ],
    );
  }

  Widget _buildMoodChart(Map<String, int> moodCounts) {
    final sections =
        moodCounts.entries.map((entry) {
          final percentage =
              (entry.value / moodCounts.values.reduce((a, b) => a + b) * 100);
          return PieChartSectionData(
            value: entry.value.toDouble(),
            title:
                '${entry.key}\n${entry.value}\n(${percentage.toStringAsFixed(1)}%)',
            color: _getMoodColorByLabel(entry.key),
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList();

    return SizedBox(
      height: 200,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  moodCounts.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _getMoodColorByLabel(entry.key),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${entry.key}: ${entry.value}',
                              style: TextStyle(
                                color: AppColors.charcoal700,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Color _getMoodColorByLabel(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return AppColors.primary500;
      case 'angry':
        return AppColors.brickRed500;
      case 'calm':
        return AppColors.oceanBlue500;
      case 'sad':
        return AppColors.indigoNight500;
      default:
        return AppColors.charcoal500;
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
