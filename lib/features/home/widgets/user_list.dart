import 'package:flutter/material.dart';
import 'package:moodsic/data/models/user.dart';

class UserList extends StatelessWidget {
  final List<UserModel> users;
  final Function(UserModel) onUserTap;

  const UserList({Key? key, required this.users, required this.onUserTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(user.displayName),
          subtitle: Text(user.email),
          onTap: () => onUserTap(user),
        );
      },
    );
  }
}
