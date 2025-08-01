import 'package:flutter/material.dart';
import 'package:moodsic/data/models/user.dart';

class UserTile extends StatelessWidget {
  final UserModel user;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const UserTile({
    Key? key,
    required this.user,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.person)),
      title: Text(user.displayName),
      subtitle: Text(user.email),
      onTap: onTap,
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'delete') {
            onDelete();
          }
        },
        itemBuilder:
            (context) => [
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
        icon: const Icon(Icons.more_vert),
      ),
    );
  }
}
