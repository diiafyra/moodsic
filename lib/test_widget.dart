import 'package:flutter/material.dart';
import 'package:moodsic/shared/widgets/playlist_card.dart';
import 'package:moodsic/shared/widgets/track_card.dart';

import 'core/widgets/search_bar.dart'; // Thêm dòng này

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo App',
      themeMode: ThemeMode.dark, // Luôn dùng dark mode
      darkTheme: ThemeData.dark(), // Sử dụng theme tối mặc định
      home: const PlaylistScreen(),
    );
  }
}

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  bool isPlaying = false;
  bool isLiked = false;
  final TextEditingController _searchController = TextEditingController();

  // void handlePlay() {
  //   setState(() {
  //     isPlaying = !isPlaying;
  //   });
  //
  //   if (isPlaying) {
  //     print("Gọi API: bắt đầu phát nhạc");
  //   } else {
  //     print("Gọi API: tạm dừng nhạc");
  //   }
  // }
  //
  // void handleLike() {
  //   setState(() {
  //     isLiked = !isLiked;
  //   });
  //
  //   if (isLiked) {
  //     print("Gọi API: thêm vào danh sách yêu thích");
  //   } else {
  //     print("Gọi API: xóa khỏi danh sách yêu thích");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Playlist Demo")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            PlaylistCard(
              id: "1",
              imageUrl: "https://i.imgur.com/ZWLFD3m.jpeg",
              description: "Nhạc Chill cho buổi tối",
              artists: ["Sơn Tùng", "JustaTee", "Đen Vâu"],
              isPlaying: isPlaying,
              isLiked: isLiked,
              // onPlay: handlePlay,
              // onLike: handleLike,
            ),
            const SizedBox(height: 16),
            TrackCard(
              id: "1",
              title: "Một Bước Yêu Vạn Dặm Đau",
              artists: ["Mr Siro"],
            ),

            CSearchBar(
              hintText: 'Tìm trong playlist',
              controller: _searchController,
              onChanged: (text) {
                // Gọi API, lọc danh sách v.v...
                print('Tìm kiếm: $text');
              },
            ),
          ],
        ),
      ),
    );
  }
}
