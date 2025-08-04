import 'package:flutter/material.dart';
import 'package:moodsic/core/config/theme/app_colors.dart';

class ProgressRing extends StatefulWidget {
  final double size;
  final bool isIndeterminate; // Thêm property để chọn kiểu loading
  final double?
  progress; // Optional progress (chỉ dùng khi isIndeterminate = false)

  const ProgressRing({
    Key? key,
    required this.size,
    this.isIndeterminate = true, // Mặc định là loading liên tục
    this.progress,
  }) : super(key: key);

  @override
  State<ProgressRing> createState() => _ProgressRingState();
}

class _ProgressRingState extends State<ProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    if (widget.isIndeterminate) {
      // Animation cho quay liên tục
      _controller = AnimationController(
        duration: const Duration(seconds: 2), // Tốc độ quay
        vsync: this,
      );

      _rotationAnimation = Tween<double>(
        begin: 0,
        end: 1,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

      // Quay liên tục
      _controller.repeat();
    } else {
      // Animation cho progress bar thông thường
      _controller = AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this,
      );

      _progressAnimation = Tween<double>(
        begin: 0,
        end: widget.progress ?? 0,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant ProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!widget.isIndeterminate && oldWidget.progress != widget.progress) {
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: widget.progress ?? 0,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
      _controller
        ..reset()
        ..forward();
    }

    // Chuyển từ progress sang indeterminate
    if (widget.isIndeterminate && !oldWidget.isIndeterminate) {
      _controller.dispose();
      _controller = AnimationController(
        duration: const Duration(seconds: 2),
        vsync: this,
      );
      _rotationAnimation = Tween<double>(
        begin: 0,
        end: 1,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child:
          widget.isIndeterminate
              ? AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle:
                        _rotationAnimation.value *
                        2 *
                        3.14159, // 2π radians = 360 degrees
                    child: CircularProgressIndicator(
                      value: null, // null = indeterminate
                      strokeWidth: widget.size * 0.08,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary900,
                      ),
                    ),
                  );
                },
              )
              : AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return CircularProgressIndicator(
                    value: _progressAnimation.value,
                    strokeWidth: widget.size * 0.08,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary900,
                    ),
                  );
                },
              ),
    );
  }
}
