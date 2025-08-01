import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    await _init();
  }

  Future<void> _init() async {
    print('[CAuthProvider] _init called');

    FirebaseAuth.instance.authStateChanges().listen((user) async {
      _loading = true;
      notifyListeners();

      print('[AuthStateChanged] user: $user');

      try {
        if (user != null) {
          _user = user;
          final idTokenResult = await user.getIdTokenResult(true);
          _role = idTokenResult.claims?['role']?.toString() ?? 'user';
          print('[AuthProvider] role: $_role');
          await _uploadFcmToken(user.uid);
        } else {
          _user = null;
          _role = null;
        }
      } catch (e, stackTrace) {
        print('[AuthProvider] Error: $e');
        print(stackTrace);
        _user = null;
        _role = null;
      }

      _loading = false;
      _initialized = true;
      notifyListeners();
    });

    _setupFcmListeners();
  }

  Future<void> _uploadFcmToken(String uid) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      print('[FCM] Token: $fcmToken');

      if (fcmToken != null && fcmToken.isNotEmpty) {
        final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
        final userDoc = await userRef.get();
        final existingToken = userDoc.data()?['fcmToken'];

        if (existingToken != fcmToken) {
          await userRef.set({'fcmToken': fcmToken}, SetOptions(merge: true));
          print('[FCM] Token uploaded to Firestore');
        } else {
          print('[FCM] Token already up-to-date');
        }
      }
    } catch (e) {
      print('[FCM] Error uploading token: $e');
    }
  }

  void _setupFcmListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
        '[FCM] Message received in foreground: ${message.notification?.title}',
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('[FCM] App opened from notification: ${message.data}');
    });
  }
}
