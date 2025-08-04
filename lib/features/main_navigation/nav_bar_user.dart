import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moodsic/core/config/theme/app_colors.dart';
import 'package:moodsic/features/fav_playlist/pages/fav_playlist.dart';
import 'package:moodsic/features/home/pages/user_home_page.dart';
import 'package:moodsic/features/profile/pages/profile_page.dart';
import 'package:moodsic/features/search/pages/createPlaylistPage.dart';
import 'package:moodsic/samples/samplePlaylists.dart';
import 'package:moodsic/features/playlist_detail_page/pages/playlist_detail.dart';
//?

class UserNavigationPage extends StatefulWidget {
  const UserNavigationPage({super.key});

  @override
  State<UserNavigationPage> createState() => _UserNavigationPageState();
}

class _UserNavigationPageState extends State<UserNavigationPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    UserHomePage(),
    FavPlaylistPage(),
    CreatePlaylistPage(),
    ProfilePage(),
    // PlaylistDetail(playlists: samplePlaylists),
    // PlaylistDetail(playlists: samplePlaylists),
    // PlaylistDetail(playlists: samplePlaylists),
    //?
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      extendBody: true,
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          // Gradient nền
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            // decoration: BoxDecoration(
            //   color: AppColors.indigoNight950, // Hoặc bất kỳ màu nào bạn muốn
            //   boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            // ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.oceanBlue800, // đỏ sẫm
                  AppColors.indigoNight950, // nâu đậm
                ],
              ),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
          ),
          // Ảnh nhiễu overlay
          Opacity(
            opacity: 0.2,
            child: Image.asset(
              'assets/noise_texture.png',
              repeat: ImageRepeat.repeat,
              width: double.infinity,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          // Nội dung nav
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(
                  0,
                  currentIndex,
                  'assets/icons/icons-navigation/menu-home.svg',
                  'Home',
                  onTap,
                ),
                _buildNavItem(
                  1,
                  currentIndex,
                  'assets/icons/icons-navigation/menu-fav.svg',
                  'Fav',
                  onTap,
                ),
                _buildNavItem(
                  2,
                  currentIndex,
                  'assets/icons/icons-navigation/menu-search.svg',
                  'Search',
                  onTap,
                ),
                _buildNavItem(
                  3,
                  currentIndex,
                  'assets/icons/icons-navigation/menu-profile.svg',
                  'Profile',
                  onTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    int currentIndex,
    String assetPath,
    String label,
    Function(int) onTap,
  ) {
    final isSelected = index == currentIndex;
    final iconColor =
        isSelected ? const Color(0xFFBD5A52) : const Color(0xFFC3DDE5);

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.scale(
            scale: 2,
            child: SvgPicture.asset(
              assetPath,
              width: 32,
              height: 32,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
          ),
          const SizedBox(height: 4),
          if (isSelected)
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: iconColor,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}
