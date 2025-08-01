import 'package:flutter/material.dart';
import 'package:moodsic/features/survey/layout/survey_layout.dart';
import 'package:moodsic/features/survey/widgets/spotify_connect_form.dart';

class ConnectSpotifyPage extends StatelessWidget {
  const ConnectSpotifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SurveyLayout(
        middleWidget:
            SpotifyConnectForm(), // 👈 Có thể truyền bất kỳ widget nào bạn muốn
      ),
    );
  }
}
