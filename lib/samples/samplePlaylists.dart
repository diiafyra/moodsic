// import 'package:moodsic/data/models/playlist_model.dart';
// import 'package:moodsic/shared/widgets/track_dto.dart';

// final List<PlaylistModel> samplePlaylists = [
//   PlaylistModel(
//     id: '1',
//     imageUrl: 'https://i.imgur.com/ZWLFD3m.jpeg',
//     description: 'Playlist chính với các bài hát yêu thích.',
//     name: 'Playlist Yêu Thích',
//     artists: ['Artist 1', 'Artist 2', 'Artist 3'],
//     isPlaying: false,
//     isLiked: true,
//     createdDate: DateTime(2025, 7, 29),
//     //   tracks: [
//     //     TrackViewmodel(
//     //       id: 't1',
//     //       title: 'Bài 1',
//     //       url: 'https://via.placeholder.com/50',
//     //       artists: ['Artist 1'],
//     //     ),
//     //     TrackViewmodel(
//     //       id: 't2',
//     //       title: 'Bài 2',
//     //       url: 'https://via.placeholder.com/50',
//     //       artists: ['Artist 2'],
//     //     ),
//     //     TrackViewmodel(
//     //       id: 't3',
//     //       title: 'Bài 3',
//     //       url: 'https://via.placeholder.com/50',
//     //       artists: ['Artist 3'],
//     //     ),
//     //     TrackViewmodel(
//     //       id: 't4',
//     //       title: 'Bài 2',
//     //       url: 'https://via.placeholder.com/50',
//     //       artists: ['Artist 2'],
//     //     ),
//     //     TrackViewmodel(
//     //       id: 't5',
//     //       title: 'Bài 2',
//     //       url: 'https://via.placeholder.com/50',
//     //       artists: ['Artist 2'],
//     //     ),
//     //     TrackViewmodel(
//     //       id: 't6',
//     //       title: 'Bài 2',
//     //       url: 'https://via.placeholder.com/50',
//     //       artists: ['Artist 2'],
//     //     ),
//     //     TrackViewmodel(
//     //       id: 't7',
//     //       title: 'Bài 2',
//     //       url: 'https://via.placeholder.com/50',
//     //       artists: ['Artist 2'],
//     //     ),
//     //     TrackViewmodel(
//     //       id: 't8',
//     //       title: 'Bài 2',
//     //       url: 'https://via.placeholder.com/50',
//     //       artists: ['Artist 2'],
//     //     ),
//     //   ],
//     isMain: true,
//   ),
//   PlaylistModel(
//     id: '2',
//     imageUrl: 'https://via.placeholder.com/200',
//     description: 'Playlist thư giãn cuối tuần.',
//     name: 'Thư Giãn',
//     artists: ['Artist A', 'Artist B'],
//     isPlaying: false,
//     isLiked: false,
//     createdDate: DateTime(2025, 7, 29),
//     // tracks: null,
//     isMain: false,
//   ),
//   PlaylistModel(
//     id: '3',
//     imageUrl: 'https://via.placeholder.com/200',
//     description: 'Playlist tập thể dục.',
//     name: 'Tập Luyện',
//     artists: ['Artist X', 'Artist Y', 'Artist Z'],
//     isPlaying: false,
//     isLiked: true,
//     createdDate: DateTime(2025, 7, 29),
//     // tracks: null,
//     isMain: false,
//   ),
// ];
import 'package:moodsic/data/models/playlist_model.dart';
import 'package:moodsic/shared/widgets/track_viewmodel.dart';

final List<TrackViewmodel> sampleTracks = [
  TrackViewmodel(
    id: 'sample_track_1',
    name: 'Sample Song 1',
    artist: 'Sample Artist A, Sample Artist B',
    album: 'Sample Album 1',
    imageUrl: 'https://via.placeholder.com/150',
    durationMs: 180000,
  ),
  TrackViewmodel(
    id: 'sample_track_2',
    name: 'Sample Song 2',
    artist: 'Sample Artist C',
    album: 'Sample Album 2',
    imageUrl: 'https://via.placeholder.com/150',
    durationMs: 200000,
  ),
];

final List<PlaylistModel> samplePlaylists = [
  PlaylistModel(
    id: 'sample_playlist_1',
    name: 'Chill Vibes',
    imageUrl: 'https://via.placeholder.com/300',
    description: 'A sample chill playlist for fallback use.',
    artists: ['Sample Curator'],
    createdDate: DateTime(2025, 1, 1),
    trackHref: 'https://api.spotify.com/v1/playlists/sample_playlist_1/tracks',
    totalTracks: 10,
    isMain: true,
  ),
  PlaylistModel(
    id: 'sample_playlist_2',
    name: 'Happy Beats',
    imageUrl: 'https://via.placeholder.com/300',
    description: 'Fallback happy playlist with energetic tracks.',
    artists: ['Fallback DJ'],
    createdDate: DateTime(2025, 2, 2),
    trackHref: 'https://api.spotify.com/v1/playlists/sample_playlist_2/tracks',
    totalTracks: 8,
    isMain: false,
  ),
];
