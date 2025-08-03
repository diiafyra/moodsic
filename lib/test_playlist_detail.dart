// import 'package:flutter/material.dart';
// import 'package:moodsic/core/config/theme/app_colors.dart';
// import 'package:moodsic/samples/samplePlaylists.dart';
// import 'package:moodsic/features/playlist_detail_page/playlist_detail.dart';
// import 'package:moodsic/data/models/playlist_model.dart';
// import 'package:moodsic/shared/widgets/track_dto.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   MyApp({super.key});

//   // Dữ liệu mẫu di chuyển vào MyApp
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Playlist App',
//       theme: ThemeData(
//         primaryColor: AppColors.oceanBlue500,
//         scaffoldBackgroundColor: AppColors.defaultTheme,
//         colorScheme: ColorScheme(
//           primary: AppColors.oceanBlue500,
//           secondary: AppColors.primary500,
//           surface: AppColors.charcoal50,
//           error: AppColors.brickRed600,
//           onPrimary: AppColors.defaultTheme,
//           onSecondary: AppColors.defaultTheme,
//           onSurface: AppColors.charcoal900,
//           onError: AppColors.defaultTheme,
//           brightness: Brightness.light,
//         ),
//       ),
//       home: Scaffold(body: PlaylistDetail(playlists: samplePlaylists)),
//     );
//   }
// }
