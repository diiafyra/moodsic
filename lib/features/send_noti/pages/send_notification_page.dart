import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SendNotificationPage extends StatefulWidget {
  const SendNotificationPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SendNotificationPageState createState() => _SendNotificationPageState();
}

class _SendNotificationPageState extends State<SendNotificationPage> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _uidController = TextEditingController();
  String _recipientType = 'All'; // Mặc định là gửi tới tất cả

  Future<void> _sendNotification() async {
    final senderId = FirebaseAuth.instance.currentUser?.uid;
    if (senderId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Admin not authenticated')),
      );
      return;
    }

    final message = _messageController.text.trim();
    if (message.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a message')));
      return;
    }

    try {
      final callable = FirebaseFunctions.instance.httpsCallable(
        'sendNotification',
      );
      final data = {
        'message': message,
        'senderId': senderId,
        'recipientType': _recipientType,
        if (_recipientType == 'Specific User')
          'userId': _uidController.text.trim(),
      };

      await callable.call(data);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification sent and saved successfully'),
        ),
      );
      _messageController.clear();
      _uidController.clear();
    } catch (e) {
      print('SendNotificationPage: Error sending notification: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error sending notification: $e')));
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _uidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chọn đối tượng nhận
            DropdownButton<String>(
              value: _recipientType,
              isExpanded: true,
              hint: const Text('Select recipient type'),
              items:
                  ['All', 'Admins', 'Users', 'Specific User']
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
              onChanged: (value) {
                setState(() {
                  _recipientType = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            // Trường nhập UID (chỉ hiển thị nếu chọn Specific User)
            if (_recipientType == 'Specific User')
              TextField(
                controller: _uidController,
                decoration: InputDecoration(
                  labelText: 'User UID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            if (_recipientType == 'Specific User') const SizedBox(height: 20),
            // Trường nhập nội dung thông báo
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Notification Message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  _messageController.text.isNotEmpty &&
                          (_recipientType != 'Specific User' ||
                              _uidController.text.isNotEmpty)
                      ? _sendNotification
                      : null,
              child: const Text('Send Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
