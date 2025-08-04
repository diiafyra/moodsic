import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moodsic/core/services/firestorage_service.dart';
import 'dart:io';
import 'package:moodsic/data/models/music_profle.dart';
import 'package:moodsic/features/profile/widgets/edit_profile_button.dart';
import 'package:moodsic/features/profile/widgets/favourite_artists_widget.dart';
import 'package:moodsic/features/profile/widgets/favourite_tracks_widget.dart.dart'
    show FavoriteTracksWidget;
import 'package:moodsic/features/profile/widgets/music_preferences_widget.dart';
import 'package:moodsic/features/profile/widgets/profile_header.dart';
import 'package:moodsic/features/profile/widgets/sign_out_button.dart';
import 'package:moodsic/features/profile/widgets/spotify_connection_widget.dart';
import 'package:moodsic/features/survey/pages/genre_selection_page.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:moodsic/core/config/theme/app_colors.dart';
import 'package:moodsic/core/services/firestore/firestore_service.dart';
import 'package:moodsic/features/survey/viewmodels/artist_viewmodel.dart';
import 'package:moodsic/shared/widgets/track_viewmodel.dart';
import 'package:moodsic/shared/states/auth_provider.dart';
import 'package:moodsic/features/survey/services/spotify_connect.dart';
import 'package:moodsic/routes/route_names.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  MusicProfile? _musicProfile;
  bool _isLoading = true;
  String? _userEmail;
  String? _avatarPath; // Đường dẫn ảnh avatar - LƯU TẠI ĐÂY

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    // _loadUserAvatar();
  }

  Future<void> _loadUserProfile() async {
    try {
      setState(() => _isLoading = true);

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _userEmail = user.email;
        final firestoreService = GetIt.instance<FirestoreService>();
        _musicProfile = await firestoreService.getMusicProfile();
      }
    } catch (e) {
      print('Error loading profile: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _changeAvatar() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final downloadUrl = await FirestorageService.pickAndUploadAvatar(
        uid: user.uid,
      );

      if (downloadUrl != null) {
        setState(() {
          _avatarPath = downloadUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Đã cập nhật ảnh đại diện"),
            backgroundColor: AppColors.primary300,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lỗi khi tải ảnh lên: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CAuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.oceanBlue800, AppColors.indigoNight950],
              ),
            ),
            child: SafeArea(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            ProfileHeader(
                              userEmail: _userEmail,
                              onAvatarTap: _changeAvatar,
                              avatarPath: _avatarPath, // bạn truyền từ state
                            ),

                            const SizedBox(height: 30),
                            SpotifyConnectionWidget(
                              authProvider: authProvider,
                              musicProfile: _musicProfile,
                              onConnect: _connectSpotify,
                            ),
                            const SizedBox(height: 20),
                            if (_musicProfile != null) ...[
                              MusicPreferencesWidget(
                                musicProfile: _musicProfile!,
                              ),
                              const SizedBox(height: 20),
                              FavoriteArtistsWidget(
                                musicProfile: _musicProfile!,
                              ),
                              const SizedBox(height: 20),
                              FavoriteTracksWidget(
                                musicProfile: _musicProfile!,
                              ),
                              const SizedBox(height: 20),
                              EditProfileButton(),
                              const SizedBox(height: 20),
                            ],
                            SignOutButton(onSignOut: _signOut),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _connectSpotify() async {
    try {
      final connectService = SpotifyConnectService();
      final result = await connectService.connectToSpotify();

      if (result != null && result['connected'] == true) {
        await context.read<CAuthProvider>().refreshUserState();
        await _loadUserProfile();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Đã kết nối Spotify thành công"),
              backgroundColor: AppColors.primary300,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Kết nối Spotify thất bại"),
              backgroundColor: AppColors.brickRed500,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Lỗi kết nối: $e"),
            backgroundColor: AppColors.brickRed500,
          ),
        );
      }
    }
  }

  Future<void> _signOut() async {
    try {
      await context.read<CAuthProvider>().signOut(context);
      if (mounted) {
        context.go(RouteNames.login);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Đăng xuất thất bại: $e')));
    }
  }
}
