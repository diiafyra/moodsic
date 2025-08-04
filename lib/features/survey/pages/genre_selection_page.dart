import 'package:flutter/material.dart';
import 'package:moodsic/features/survey/layout/survey_layout.dart';
import 'package:moodsic/features/survey/pages/artist_selection_page.dart';
import 'package:moodsic/features/survey/widgets/genre_selection_widget.dart';

class GenreSelectionPage extends StatelessWidget {
  const GenreSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SurveyLayout(
      middleWidget: GenreSelectionWidget(
        // onSelectionChanged: (selectedGenres) {
        //   print('Selected genres: $selectedGenres');
        // },
      ),
      onBack: () {
        Navigator.pop(context);
      },
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ArtistSelectionPage()),
        );
      },
      showNavigation: true,
    );
  }
}
