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

  bool _hasProfiles = false;
  bool _hasConnectedSpotify = false;

  // Thêm flag để track quá trình đăng nhập
  bool _isAuthenticating = false;

  User? get user => _user;
  String? get role => _role;
  bool get isLoading => _loading || _isAuthenticating; // Cập nhật này
  bool get isInitialized => _initialized;
  bool get hasProfiles => _hasProfiles;
  bool get hasConnectedSpotify => _hasConnectedSpotify;
  bool get isAuthenticating => _isAuthenticating;

  CAuthProvider._internal();

  // Thêm method để set authenticating state
  void setAuthenticating(bool value) {
    if (_isAuthenticating != value) {
      _isAuthenticating = value;
      notifyListeners();
    }
  }

  Future<void> init() async {
    print('[CAuthProvider] init called, initialized: $_initialized');

    _loading = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        _user = user;
        final idTokenResult = await user.getIdTokenResult(true);
        _role = idTokenResult.claims?['role']?.toString() ?? 'user';
        await _uploadFcmToken(user.uid);

        await _loadUserContext(user.uid);
      } else {
        _user = null;
        _role = null;
        _hasProfiles = false;
        _hasConnectedSpotify = false;
      }
    } catch (e, stackTrace) {
      print('[AuthProvider] Error during init: $e');
      print(stackTrace);
      _user = null;
      _role = null;
      _hasProfiles = false;
      _hasConnectedSpotify = false;
    }

    print(
      '[AuthProvider] Init completed - User: $_user, Role: $_role, Spotify: $_hasConnectedSpotify, Profiles: $_hasProfiles',
    );

    _loading = false;
    _initialized = true;
    _isAuthenticating = false; // Đảm bảo reset flag này
    notifyListeners();
  }

  Future<void> _loadUserContext(String uid) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

      final userDoc = await userRef.get();
      _hasConnectedSpotify = userDoc.data()?['spotify'] != null;

      final profilesRef = userRef.collection('profiles');
      final profilesSnapshot = await profilesRef.limit(1).get();
      _hasProfiles = profilesSnapshot.docs.isNotEmpty;

      print(
        '[AuthProvider] Context loaded - Spotify: $_hasConnectedSpotify, Profiles: $_hasProfiles',
      );
    } catch (e) {
      print('[AuthProvider] Error loading user context: $e');
      _hasProfiles = false;
      _hasConnectedSpotify = false;
    }
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

  // Method để force reload sau khi đăng nhập
  Future<void> refreshUserState() async {
    print('[AuthProvider] Force refreshing user state');
    _loading = true;
    notifyListeners();

    await init();
  }

  void reset() {
    _user = null;
    _role = null;
    _hasProfiles = false;
    _hasConnectedSpotify = false;
    _loading = false;
    _initialized = false;
    _isAuthenticating = false;
    notifyListeners();
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      reset();

      // (Tùy chọn) Nếu muốn điều hướng sau khi đăng xuất:
      // Navigator.pushReplacementNamed(context, '/login'); hoặc '/splash'
      print('[AuthProvider] User signed out');
    } catch (e) {
      print('[AuthProvider] Error during sign out: $e');
    }
  }
}
