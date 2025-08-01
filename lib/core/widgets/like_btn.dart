import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LikeButton extends StatefulWidget {
  final int size;
  final bool isLiked;
  final String id;

  const LikeButton({
    super.key,
    required this.id,
    required this.size,
    required this.isLiked,
  });

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  late bool isLiked = widget.isLiked;

  @override
  void initState() {
    super.initState();
    isLiked = widget.isLiked; // Lấy trạng thái ban đầu từ widget
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isLiked = !isLiked;
          print("Toggled isLiked: $isLiked");
        });
      },
      child: Container(
        width: widget.size.toDouble() + 4,
        height: widget.size.toDouble() + 4,
        child: Center(
          child: SvgPicture.asset(
            isLiked
                ? 'assets/icons/like_filled.svg'
                : 'assets/icons/like_outline.svg',
            width: widget.size.toDouble(),
            height: widget.size.toDouble(),
          ),
        ),
      ),
    );
  }
}
