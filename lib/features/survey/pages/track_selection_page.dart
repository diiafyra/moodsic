import 'package:flutter/material.dart';
import 'package:moodsic/features/survey/layout/survey_layout.dart';
import 'package:moodsic/features/survey/widgets/track_selection_widget.dart';
import 'package:moodsic/shared/states/survey_provider.dart';
import 'package:moodsic/shared/states/auth_provider.dart';
import 'package:provider/provider.dart';

class TrackSelectionPage extends StatelessWidget {
  const TrackSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final surveyProvider = Provider.of<SurveyProvider>(context, listen: false);

    return SurveyLayout(
      middleWidget: TrackSelectionWidget(
        onSelectionChanged: (tracks) {
          surveyProvider.setTracks(tracks);
        },
        maxSelection: 10,
      ),
      onBack: () => Navigator.pop(context),
      onNext: () async {
        try {
          // Hiện loading state
          CAuthProvider.instance.setAuthenticating(true);

          // Save music profile
          await surveyProvider.saveMusicProfile();

          // Cập nhật auth provider sau khi save thành công
          await CAuthProvider.instance.refreshUserState();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lưu profile thành công')),
          );

          // Router sẽ tự động redirect đến trang phù hợp
        } catch (e) {
          // Tắt loading state nếu có lỗi
          CAuthProvider.instance.setAuthenticating(false);

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Lỗi khi lưu profile: $e')));
        }
      },
      showNavigation: true,
    );
  }
}
