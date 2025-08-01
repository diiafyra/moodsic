import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moodsic/features/users/services/notification_service.dart';

class UserDetailPage extends StatefulWidget {
  final String uid;

  const UserDetailPage({Key? key, required this.uid}) : super(key: key);

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final TextEditingController _notificationController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _notificationController.dispose();
    super.dispose();
  }

  Future<void> _sendNotification() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      _showSnackBar('Admin not authenticated');
      return;
    }

    final senderId = currentUser.uid;
    final message = _notificationController.text.trim();

    if (message.isEmpty) {
      _showSnackBar('Please enter a message');
      return;
    }

    setState(() => _loading = true);

    try {
      await NotificationService.callSendNotificationFunction(
        userId: widget.uid,
        senderId: senderId,
        message: message,
      );
      _showSnackBar('Notification sent successfully!');
    } catch (e) {
      _showSnackBar('Error sending notification: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Detail')),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance
                .collection('users')
                .doc(widget.uid)
                .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User not found.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final fcmToken = data['fcmToken'] ?? 'Not available';
          final displayName = data['displayName'] ?? 'Unknown';
          final email = data['email'] ?? 'Unknown';
          final provider = data['provider'] ?? 'Unknown';
          final createdAt = formatDate(data['createdAt']);
          final updatedAt = formatDate(data['updatedAt']);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        child: Icon(Icons.person, size: 40),
                      ),
                      const SizedBox(height: 20),
                      _buildDetailRow('UID', widget.uid),
                      _buildDetailRow('Display Name', displayName),
                      _buildDetailRow('Email', email),
                      _buildDetailRow('Provider', provider),
                      _buildDetailRow('Created At', createdAt),
                      _buildDetailRow('Updated At', updatedAt),
                      _buildDetailRow('FCM Token', fcmToken),
                      const SizedBox(height: 20),

                      TextField(
                        controller: _notificationController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Enter notification message',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      ElevatedButton(
                        onPressed: _loading ? null : _sendNotification,
                        child:
                            _loading
                                ? const CircularProgressIndicator()
                                : const Text('Send Notification'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

String formatDate(dynamic value) {
  if (value is Timestamp) {
    return value.toDate().toLocal().toString();
  } else if (value is String) {
    final parsed = DateTime.tryParse(value);
    return parsed?.toLocal().toString() ?? 'N/A';
  }
  return 'N/A';
}
