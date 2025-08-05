import 'package:flutter/material.dart';

class _SmallSignOutButton extends StatelessWidget {
  final VoidCallback onSignOut;

  const _SmallSignOutButton({Key? key, required this.onSignOut})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Đăng xuất',
      child: IconButton(
        icon: const Icon(Icons.logout),
        color: Colors.redAccent,
        onPressed: () async {
          final shouldSignOut = await showDialog<bool>(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('Xác nhận đăng xuất'),
                  content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Hủy'),
                    ),
                    TextButton(
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
