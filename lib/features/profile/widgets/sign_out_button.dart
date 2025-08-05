import 'package:flutter/material.dart';
import 'package:moodsic/core/config/theme/app_colors.dart';

class SignOutButton extends StatelessWidget {
  final VoidCallback onSignOut;

  const SignOutButton({super.key, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brickRed500,
          foregroundColor: AppColors.primary50,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
        icon: const Icon(Icons.logout, size: 20),
        label: const Text(
          'Đăng xuất',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        onPressed: () async {
          final shouldSignOut = await showDialog<bool>(
            context: context,
            builder:
                (context) => AlertDialog(
                  backgroundColor: AppColors.indigoNight800,
                  title: const Text(
                    'Xác nhận đăng xuất',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: const Text(
                    'Bạn có chắc chắn muốn đăng xuất?',
                    style: TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text(
                        'Hủy',
                        style: TextStyle(color: AppColors.primary300),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brickRed500,
                        foregroundColor: AppColors.primary50,
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Đăng xuất'),
                    ),
                  ],
                ),
          );

          if (shouldSignOut == true) {
            onSignOut();
          }
        },
      ),
    );
  }
}
