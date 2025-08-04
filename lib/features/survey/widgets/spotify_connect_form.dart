import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moodsic/core/config/theme/app_colors.dart';
import 'package:moodsic/features/survey/services/spotify_connect.dart'; // cần import service mới

class SpotifyConnectForm extends StatelessWidget {
  const SpotifyConnectForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      // hoặc dùng Expanded + Center nếu nằm trong Column khác
      child: Column(
        // mainAxisSize: MainAxisSize.,
        children: [
          Text(
            'LIÊN KẾT SPOTIFY GIÚP MOODSIC HIỂU THÊM VỀ BẠN',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary300, // Màu nền
              foregroundColor: AppColors.primary50, // Màu chữ + icon
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            icon: SvgPicture.asset(
              'assets/icons/spotify_icon.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                Colors.white, // hoặc AppColors.primary50
                BlendMode.srcIn,
              ),
            ),
            label: const Text("Connect with Spotify"),
            onPressed: () async {
              final connectService = SpotifyConnectService();
              final result = await connectService.connectToSpotify();

              if (result != null && result['connected'] == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Đã kết nối Spotify thành công"),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Kết nối Spotify thất bại")),
                );
              }
            },
          ),
          const SizedBox(height: 8),

          const Text(
            "*bỏ qua nếu bạn chưa muốn liên kết",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Recursive',
              fontSize: 10,
              fontVariations: [
                FontVariation('wght', 200),
                FontVariation('MONO', 1),
                FontVariation('CASL', 1),
              ],
              color: AppColors.primary50,
            ),
          ),
        ],
      ),
    );
  }
}
