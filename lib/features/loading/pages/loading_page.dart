import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moodsic/features/loading/widgets/animated_logo_text.dart';
import 'package:moodsic/features/loading/widgets/progess_ring.dart';
import 'package:moodsic/shared/states/auth_provider.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final provider = CAuthProvider.instance;
    if (!provider.isInitialized) {
      await provider.init(); // Đợi init hoàn tất
    }

    // Lúc này provider đã cập nhật thông tin user & role
    if (mounted) {
      if (provider.user == null) {
        context.go('/login');
      } else if (provider.role == 'admin') {
        context.go('/admin-home');
      } else {
        context.go('/user-home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final guitarSize = MediaQuery.of(context).size.width * 0.6;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/images/guitar_base.svg',
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.topCenter, // hoặc Alignment(x, y)
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.243,
                left: screenWidth * 0.003,
              ),
              child: ProgressRing(size: guitarSize * 0.52, progress: 1),
            ),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 0), // ví dụ padding 10% màn hình
              child: SizedBox(
                height: screenHeight * 0.51, // 👈 chiều cao chiếm 30% màn hình
                child: SvgPicture.asset(
                  'assets/images/guitar_string.svg',
                  fit: BoxFit.contain, // hoặc BoxFit.cover tùy thiết kế
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(child: AnimatedLogoText()),
          ),
        ],
      ),
    );
  }
}
