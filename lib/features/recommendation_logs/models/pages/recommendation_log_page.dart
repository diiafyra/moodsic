import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:moodsic/core/config/theme/app_colors.dart';
import 'package:moodsic/core/services/firestore/firestore_service.dart';
import 'package:moodsic/features/recommendation_logs/models/recommendation_log.dart';

// Main UI Widget
class RecommendationLogsScreen extends StatefulWidget {
  const RecommendationLogsScreen({Key? key}) : super(key: key);

  @override
  State<RecommendationLogsScreen> createState() =>
      _RecommendationLogsScreenState();
}

class _RecommendationLogsScreenState extends State<RecommendationLogsScreen> {
  final firestoreService = GetIt.instance<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.oceanBlue50,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
          color: AppColors.indigoNight800,
        ),
        title: const Text(
          'Recommendation History',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.indigoNight900,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.indigoNight800),
      ),
      body: StreamBuilder<List<RecommendationLog>>(
        stream: firestoreService.getUserRecommendationLogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.oceanBlue600),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.brickRed500,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Something went wrong',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.charcoal800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.charcoal600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final logs = snapshot.data ?? [];

          if (logs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.music_note_outlined,
                    size: 64,
                    color: AppColors.charcoal400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No recommendations yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.charcoal600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your music recommendations will appear here',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.charcoal500,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            color: AppColors.oceanBlue600,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: logs.length,
              itemBuilder: (context, index) {
                return RecommendationLogCard(log: logs[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

// Card widget cho mỗi recommendation log
class RecommendationLogCard extends StatelessWidget {
  final RecommendationLog log;

  const RecommendationLogCard({Key? key, required this.log}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.oceanBlue200.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            if (log.imageUrl != null && log.imageUrl!.isNotEmpty)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                  imageUrl: log.imageUrl!,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        color: AppColors.oceanBlue100,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.oceanBlue600,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        color: AppColors.charcoal100,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 48,
                            color: AppColors.charcoal400,
                          ),
                        ),
                      ),
                ),
              ),

            // Content section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppColors.charcoal500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat(
                          'MMM dd, yyyy • HH:mm',
                        ).format(log.timestamp),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.charcoal500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  if (log.moodText.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      log.moodText,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.indigoNight800,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ],

                  // Keywords
                  if (log.keywords.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children:
                          log.keywords.map((keyword) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.primary200,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                keyword,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ],

                  // Mood indicators
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildMoodIndicator(
                        'Arousal',
                        log.arousal,
                        AppColors.oceanBlue600,
                      ),
                      const SizedBox(width: 16),
                      _buildMoodIndicator(
                        'Valence',
                        log.valence,
                        AppColors.indigoNight600,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodIndicator(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.charcoal600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Container(
              width: 60,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.charcoal200,
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (value + 1) / 2, // Convert from -1,1 to 0,1
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              value.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 11,
                color: AppColors.charcoal600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
