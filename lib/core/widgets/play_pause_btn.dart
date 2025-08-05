import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../features/playlist_suggestion/controller/play_controller.dart';

class PlayPauseButton extends StatelessWidget {
  final String id;
  final int size;

  const PlayPauseButton({
    super.key,
    required this.id,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PlayController>(context);

    final isPlaying = controller.isPlaying(id);

    return GestureDetector(
      onTap: () => controller.togglePlay(id),
      child: Container(
        width: size.toDouble() + 4,
        height: size.toDouble() + 4,
        child: Center(
          child: SvgPicture.asset(
            isPlaying ? 'assets/icons/pause.svg' : 'assets/icons/play.svg',
            width: size.toDouble(),
            height: size.toDouble(),
          ),
        ),
      ),
    );
  }
}
