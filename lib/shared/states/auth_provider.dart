import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class CAuthProvider extends ChangeNotifier {
  static final CAuthProvider instance = CAuthProvider._internal();

  User? _user;
  String? _role;
  bool _loading = true;
  bool _initialized = false;

  User? get user => _user;
  String? get role => _role;
  bool get isLoading => _loading;
  bool get isInitialized => _initialized;

  CAuthProvider._internal();

  Future<void> init() async {
    if (_initialized) return;
    print('[CAuthProvider] init called');
    _loading = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        _user = user;
        final idTokenResult = await user.getIdTokenResult(true);
        _role = idTokenResult.claims?['role']?.toString() ?? 'user';
        await _uploadFcmToken(user.uid);
      } else {
        _user = null;
        _role = null;
      }
    } catch (e, stackTrace) {
      print('[AuthProvider] Error during init: $e');
      print(stackTrace);
      _user = null;
      _role = null;
    }
    print('[user] ${_user}');

    _loading = false;
    _initialized = true;
    notifyListeners();
  }

  Future<void> _uploadFcmToken(String uid) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();

      if (fcmToken != null && fcmToken.isNotEmpty) {
        final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
        final userDoc = await userRef.get();
        final existingToken = userDoc.data()?['fcmToken'];

        if (existingToken != fcmToken) {
          await userRef.set({'fcmToken': fcmToken}, SetOptions(merge: true));
        }
      }
    } catch (e) {
      print('[FCM] Error uploading token: $e');
    }
  }
}
