// lib/features/onboarding/presentation/widgets/animated_logo_text.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:moodsic/core/config/theme/app_colors.dart';

class AnimatedLogoText extends StatelessWidget {
  const AnimatedLogoText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
          "MOODSIC",
          style: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontFamily: 'Recursive',
            color: AppColors.oceanBlue50,
            fontVariations: [
              FontVariation('wght', 900),
              FontVariation('MONO', 1),
              FontVariation('CASL', 1),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 1.2.seconds)
        .then()
        .slideY(begin: 0.6, duration: 800.ms)
        .then()
        .shimmer(duration: 1.seconds);
  }
}
