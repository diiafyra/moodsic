import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:moodsic/data/models/playlist_model.dart';
import 'package:moodsic/core/services/firestore/firestore_service.dart';

class LikeButton extends StatefulWidget {
  final int size;
  final bool isLiked;
  final PlaylistModel model;

  const LikeButton({
    super.key,
    required this.model,
    required this.size,
    required this.isLiked,
  });

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  final _firestoreService = GetIt.I<FirestoreService>();

  late bool isLiked;

  @override
  void initState() {
    super.initState();
    isLiked = widget.isLiked;
  }

  void _toggleLike() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    setState(() => isLiked = !isLiked);

    try {
      if (isLiked) {
        await _firestoreService.likePlaylist(widget.model);
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Added to your liked playlists')),
        );
      } else {
        await _firestoreService.unlikePlaylist(widget.model.id);
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Removed from liked playlists')),
        );
      }
    } catch (e) {
      debugPrint('Failed to toggle like: $e');
      setState(() => isLiked = !isLiked);
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Something went wrong')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleLike,
      child: SizedBox(
        width: widget.size.toDouble() + 4,
        height: widget.size.toDouble() + 4,
        child: Center(
          child: SvgPicture.asset(
            isLiked
                ? 'assets/icons/like_filled.svg'
                : 'assets/icons/like_outline.svg',
            width: widget.size.toDouble(),
            height: widget.size.toDouble(),
          ),
        ),
      ),
    );
  }
}
