import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/features/profile/models/maintenance_request_model.dart';
import 'package:real_estate_app/features/profile/views/screens/maintenance/maintenance_media_view_screen.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class MediaGallery extends StatelessWidget {
  final MaintenanceDetailModel detail;
  const MediaGallery({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    final media = [
      ...detail.media.images.map((e) => e.url),
      ...detail.media.videos.map((e) => e.url),
    ];
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: media.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final allMedia = [...detail.media.images, ...detail.media.videos];
          final isVideoList = [
            ...detail.media.images.map((_) => false),
            ...detail.media.videos.map((_) => true),
          ];
          return GestureDetector(
            onTap: () => Get.to(
              () => MaintenanceMediaViewScreen(
                mediaItems: allMedia,
                isVideoList: isVideoList,
                initialIndex: index,
              ),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AppImage(path: media[index], height: 100, width: 100),
                ),
                if (isVideoList[index])
                  const Positioned.fill(
                    child: Center(
                      child: Icon(
                        Icons.play_circle_fill,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
