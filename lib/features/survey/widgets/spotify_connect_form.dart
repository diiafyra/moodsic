import 'package:flutter/material.dart';
import 'package:moodsic/features/survey/services/spotify_connect.dart'; // cần import service mới

class SpotifyConnectForm extends StatelessWidget {
  const SpotifyConnectForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Kết nối Spotify để tiếp tục",
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          icon: const Icon(Icons.music_note),
          label: const Text("Connect with Spotify"),
          onPressed: () async {
            final connectService = SpotifyConnectService();
            final result = await connectService.connectToSpotify();

            if (result != null && result['connected'] == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Đã kết nối Spotify thành công")),
              );
              // TODO: điều hướng tiếp hoặc lưu thông tin
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Kết nối Spotify thất bại")),
              );
            }
          },
        ),
      ],
    );
  }
}
