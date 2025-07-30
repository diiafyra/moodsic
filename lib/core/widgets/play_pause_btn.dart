import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PlayPauseButton extends StatelessWidget {
  final bool isPlaying;
  final void Function(String id) onTap;
  final String id;
  final double size;

  const PlayPauseButton({
    super.key,
    required this.isPlaying,
    required this.onTap,
    required this.id,
    this.size = 28.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(id),
      child: SvgPicture.asset(
        isPlaying ? 'assets/icons/pause.svg' : 'assets/icons/play.svg',
        width: size,
        height: size,
      ),
    );
  }
}
