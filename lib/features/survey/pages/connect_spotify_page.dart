import 'package:flutter/material.dart';
import 'package:moodsic/features/survey/layout/survey_layout.dart';
import 'package:moodsic/features/survey/pages/genre_selection_page.dart';
import 'package:moodsic/features/survey/widgets/spotify_connect_form.dart';

class ConnectSpotifyPage extends StatelessWidget {
  const ConnectSpotifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SurveyLayout(
      middleWidget: SpotifyConnectForm(),
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GenreSelectionPage()),
        );
      },
      onBack: () {
        Navigator.pop(context); // Thoát nếu ở trang đầu
      },
      showNavigation: true,
    );
  }
}
