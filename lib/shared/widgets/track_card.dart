import 'dart:ui' show FontVariation;
import 'package:flutter/material.dart';
import '../../core/config/theme/app_colors.dart';

class TrackCard extends StatelessWidget {
  final String id;
  final String title;
  final String? url;
  final String artists;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool
  isCompact; // Thêm thuộc tính để hiển thị dạng compact (cho danh sách đã chọn)

  const TrackCard({
    super.key,
    required this.id,
    required this.title,
    this.url,
    required this.artists,
    this.isSelected = false,
    this.onTap,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      // Hiển thị dạng compact cho danh sách đã chọn (avatar tròn)
      return Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: url != null ? NetworkImage(url!) : null,
                backgroundColor: AppColors.oceanBlue600,
                child:
                    url == null
                        ? const Icon(
                          Icons.music_note,
                          color: Colors.white,
                          size: 24,
                        )
                        : null,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ],
          ),

          // Nút X nổi lên trên cùng góc phải
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 12),
              ),
            ),
          ),
        ],
      );
    }

    // Hiển thị dạng đầy đủ cho kết quả tìm kiếm
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Card(
          color: Colors.white.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: url != null ? NetworkImage(url!) : null,
              backgroundColor: AppColors.oceanBlue600,
              child:
                  url == null
                      ? const Icon(Icons.music_note, color: Colors.white)
                      : null,
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              artists,
              style: TextStyle(color: Colors.grey[600]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Icon(
              isSelected ? Icons.check_circle : Icons.add_circle,
              color: AppColors.oceanBlue600,
            ),
          ),
        ),
      ),
    );
  }
}
