import 'dart:ui' show FontVariation;
import 'package:flutter/material.dart';
import 'package:moodsic/core/config/theme/app_colors.dart';

class SurveyLayout extends StatelessWidget {
  final Widget middleWidget; // Widget chính hiển thị ở giữa
  final Widget? fixedBottomWidget; // Widget cố định ở cuối (optional)
  final VoidCallback? onBack; // Callback cho nút quay lại
  final VoidCallback? onNext; // Callback cho nút tiếp theo
  final bool showNavigation; // Quyết định hiển thị thanh điều hướng

  const SurveyLayout({
    super.key,
    required this.middleWidget,
    this.fixedBottomWidget,
    this.onBack,
    this.onNext,
    this.showNavigation = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.oceanBlue600,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ), // Padding căn lề 2 bên cho toàn bộ layout
          child: Column(
            children: [
              // Phần cuộn được
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 80), // Khoảng cách phía trên
                      // Phần tiêu đề
                      Column(
                        children: const [
                          Text(
                            "WELCOME TO ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Recursive',
                              fontSize: 50,
                              fontVariations: [
                                FontVariation('wght', 900),
                                FontVariation('MONO', 0),
                                FontVariation('CASL', 1),
                              ],
                              color: AppColors.primary50,
                            ),
                          ),
                          Text(
                            "MOOSIC",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Recursive',
                              fontSize: 50,
                              fontVariations: [
                                FontVariation('wght', 900),
                                FontVariation('MONO', 0),
                                FontVariation('CASL', 1),
                              ],
                              color: AppColors.brickRed600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 32,
                      ), // Khoảng cách giữa tiêu đề và nội dung
                      // Nội dung chính được truyền vào
                      middleWidget,
                    ],
                  ),
                ),
              ),

              // Phần fixed bottom widget (nếu có)
              if (fixedBottomWidget != null)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                    bottom: 8,
                  ), // Khoảng cách với nav
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(
                      16,
                    ), // Bo góc cho fixed bottom
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, -2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: fixedBottomWidget!,
                ),

              // Thanh điều hướng dưới cùng - LUÔN FIXED với width nhỏ hơn và bo góc
              if (showNavigation)
                Container(
                  width: double.infinity, // Full width để tạo vùng trong suốt
                  alignment: Alignment.center, // Căn giữa nav bar
                  padding: const EdgeInsets.only(bottom: 16), // Margin dưới
                  child: Container(
                    width:
                        MediaQuery.of(context).size.width *
                        0.9, // Width = 60% màn hình
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(
                        0.15,
                      ), // Màu nền trong suốt
                      borderRadius: BorderRadius.circular(30), // Bo góc tròn
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(0, 4),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _NavigationButton(
                          icon: Icons.arrow_back_ios_rounded,
                          onTap: onBack,
                        ),
                        _NavigationButton(
                          icon: Icons.arrow_forward_ios_rounded,
                          onTap: onNext,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  final IconData icon; // Biểu tượng của nút
  final VoidCallback? onTap; // Callback khi nhấn nút

  const _NavigationButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.25),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ), // Icon nhỏ hơn một chút
      ),
    );
  }
}
