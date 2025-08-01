import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SadButton extends StatefulWidget {
  final VoidCallback onTap;

  const SadButton({super.key, required this.onTap});

  @override
  State<SadButton> createState() => _SadButtonState();
}

class _SadButtonState extends State<SadButton> {
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
                ? 'assets/icons/sad_fill.svg'
                : 'assets/icons/sad_outline.svg',
            width: 24,
            height: 24,
          ),
        ),
      ),
    );
  }
}
