import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FirestorageService {
  static Future<String?> pickAndUploadAvatar({required String uid}) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      maxHeight: 300,
      imageQuality: 80,
    );

    if (pickedFile == null) return null;

    final file = File(pickedFile.path);
    final fileName = 'avatar.jpg'; // có thể cho phép tùy chỉnh
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('users')
        .child(uid)
        .child('avatars')
        .child(fileName);

    try {
      await storageRef.putFile(file);
      final downloadUrl = await storageRef.getDownloadURL();

      // Cập nhật photoURL vào FirebaseAuth
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePhotoURL(downloadUrl);
        await user.reload();
      }

      return downloadUrl;
    } catch (e) {
      print("❌ Upload avatar failed: $e");
      rethrow;
    }
  }
}
