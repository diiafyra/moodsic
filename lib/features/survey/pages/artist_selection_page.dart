import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodsic/features/survey/layout/survey_layout.dart';
import 'package:moodsic/features/survey/pages/track_selection_page.dart';
import 'package:moodsic/features/survey/widgets/artist_selection_widget.dart';
import 'package:moodsic/features/survey/viewmodels/artist_selection_viewmodel.dart';
import 'package:moodsic/features/survey/widgets/artist_selection/selected_artist_widget.dart';
import 'package:moodsic/features/survey/widgets/artist_selection/search_counter_widget.dart';
import 'package:moodsic/domains/usecases/search_artists.dart';

final getIt = GetIt.instance;

class ArtistSelectionPage extends StatelessWidget {
  const ArtistSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SurveyLayout(
      // Middle widget - sử dụng lại ArtistSelectionWidget
      middleWidget: Column(
        children: [
          // Artist selection widget chính
          ArtistSelectionWidget(maxSelection: 10),
        ],
      ),

      // Navigation callbacks
      onBack: () => Navigator.pop(context),
      onNext:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TrackSelectionPage()),
          ),
      showNavigation: true,
    );
  }
}
