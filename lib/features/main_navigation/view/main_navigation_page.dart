import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
//import '../../home/pages/home_page.dart';
//?

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    //HomePage(), // Thay bằng HomePage()
    Placeholder(),
    Placeholder(),
    Placeholder(),
    //?
  ];

  @override
  Widget build(BuildContext context) {
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(
              0,
              currentIndex,
              'assets/icons/icons-navigation/menu - home.svg',
              'Home',
              onTap,
            ),
            _buildNavItem(
              1,
              currentIndex,
              'assets/icons/icons-navigation/menu - wallet.svg',
              'Far',
              onTap,
            ),
            _buildNavItem(
              2,
              currentIndex,
              'assets/icons/icons-navigation/menu - analysis.svg',
              'Search',
              onTap,
            ),
            _buildNavItem(
              3,
              currentIndex,
              'assets/icons/icons-navigation/menu - profile.svg',
              'Profile',
              onTap,
            ),
          ],
        ),
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
    final iconColor = isSelected ? const Color(0xFFBD5A52) : const Color(0xFFC3DDE5);

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

