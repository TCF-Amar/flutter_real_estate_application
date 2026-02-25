import 'package:flutter/material.dart';
import 'package:real_estate_app/features/explore/models/property_model.dart';
import 'package:real_estate_app/features/shared/widgets/header_text.dart';

class VideoPreview extends StatelessWidget {
  final List<MediaItem> videos;
  const VideoPreview({super.key, required this.videos});

  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(top: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderText(text: "Video"),
          // const SizedBox(height: 16),
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[300],
            ),
            // color: Colors.grey[300],
            child: const Center(child: Text("Video player goes here")),
          ),
        ],
      ),
    );
  }
}
