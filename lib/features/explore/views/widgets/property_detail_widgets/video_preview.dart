import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/explore/models/property_model.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';
import 'package:real_estate_app/features/shared/widgets/header_text.dart';
import 'package:video_player/video_player.dart';

class VideoPreview extends StatefulWidget {
  final List<MediaItem> video;
  const VideoPreview({super.key, required this.video});

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    if (widget.video.isNotEmpty) {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.video.first.url),
      );

      _initializeVideoPlayerFuture = _controller!.initialize();

      _controller!.addListener(() {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayback() {
    if (_controller == null) return;

    if (_controller!.value.isPlaying) {
      _controller!.pause();
    } else {
      _controller!.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.video.isEmpty || _controller == null) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderText(text: "Video Tour"),
          const SizedBox(height: 16),

          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: Colors.black,
              child: FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          VideoPlayer(_controller!),

                          GestureDetector(
                            onTap: _togglePlayback,
                            child: Container(
                              color: Colors.black.withOpacity(0.2),
                              alignment: Alignment.center,
                              child: Icon(
                                _controller!.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return const AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
