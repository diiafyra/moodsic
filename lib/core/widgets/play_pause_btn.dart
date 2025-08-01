import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PlayPauseButton extends StatefulWidget {
  final bool isPlaying;
  final int size;
  final String id;

  const PlayPauseButton({
    super.key,
    required this.id,
    required this.size,
    required this.isPlaying,
  });

  @override
  State<PlayPauseButton> createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton> {
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isPlaying = !isPlaying;
        });
      },
      child: Container(
        width: widget.size.toDouble() + 4,
        height: widget.size.toDouble() + 4,
        child: Center(
          child: SvgPicture.asset(
            isPlaying ? 'assets/icons/pause.svg' : 'assets/icons/play.svg',
            width: widget.size.toDouble(),
            height: widget.size.toDouble(),
          ),
        ),
      ),
    );
  }
}
