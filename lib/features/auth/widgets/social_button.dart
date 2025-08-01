// features/auth/widgets/social_buttons.dart
import 'package:flutter/material.dart';
import 'package:moodsic/features/auth/services/spotify_auth_service.dart';
import '../services/google_auth_service.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSocialButton(
          icon: Icons.g_mobiledata,
          onPressed: () async {
            final user = await GoogleAuthService().signInWithGoogle();
            if (user != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Đăng nhập thành công: ${user.email}")),
              );
            }
          },
        ),
        const SizedBox(width: 40),
        _buildSocialButton(
          icon: Icons.music_note,
          onPressed: () async {
            final token = await SpotifyAuthService().signInWithSpotify();
            if (token != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Spotify token: $token")));
            }
          },
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Icon(icon, size: 32, color: const Color(0xFF1F4C5B)),
      ),
    );
  }
}
