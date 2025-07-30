import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LikeButton extends StatelessWidget {
  final bool isLiked;
  final void Function(String id) onTap;
  final String id;
  final double size;

  const LikeButton({
    super.key,
    required this.isLiked,
    required this.onTap,
    required this.id,
    this.size = 28.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(id),
      child: SvgPicture.asset(
        isLiked
            ? 'assets/icons/like_filled.svg'
            : 'assets/icons/like_outline.svg',
        width: size,
        height: size,
      ),
    );
  }
}
