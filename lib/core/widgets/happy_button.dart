import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HappyButton extends StatefulWidget {
  final VoidCallback onTap;

  const HappyButton({super.key, required this.onTap});

  @override
  State<HappyButton> createState() => _HappyButtonState();
}

class _HappyButtonState extends State<HappyButton> {
  bool isHappy = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isHappy = !isHappy;
        });
        widget.onTap(); // Đảm bảo gọi callback
      },
      child: Container(
        width: 28,
        height: 28,

        child: Center(
          child: SvgPicture.asset(
            isHappy
                ? 'assets/icons/lol_fill.svg'
                : 'assets/icons/lol_outline.svg',
            width: 24,
            height: 24,
          ),
        ),
      ),
    );
  }
}
