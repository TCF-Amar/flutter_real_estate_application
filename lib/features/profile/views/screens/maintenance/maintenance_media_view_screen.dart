import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/constants/environments.dart';
import 'package:real_estate_app/features/profile/models/maintenance_request_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class MaintenanceMediaViewScreen extends StatefulWidget {
  final List<MediaItem> mediaItems;
  final List<bool> isVideoList;
  final int initialIndex;

  const MaintenanceMediaViewScreen({
    super.key,
    required this.mediaItems,
    required this.isVideoList,
    required this.initialIndex,
  });

  @override
  State<MaintenanceMediaViewScreen> createState() =>
      _MaintenanceMediaViewScreenState();
}

class _MaintenanceMediaViewScreenState extends State<MaintenanceMediaViewScreen> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onThumbnailTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const DefaultAppBar(title: "Attached Image"),
      body: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.mediaItems.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                final isVideo = widget.isVideoList[index];
                final url = widget.mediaItems[index].url;
                final fullUrl = url.startsWith('http')
                    ? url
                    : "${Environments.baseUrl}$url";
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: isVideo
                        ? AppVideoPlayer(
                            url: fullUrl,
                            height: double.infinity,
                          )
                        : AppImage(
                            path: url,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                );
              },
            ),
          ),
          const Spacer(),
          Container(
            height: 120,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: widget.mediaItems.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final isSelected = _currentIndex == index;
                return GestureDetector(
                  onTap: () => _onThumbnailTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            isSelected ? AppColors.primary : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                              )
                            ]
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        children: [
                          AppImage(
                            path: widget.mediaItems[index].url,
                            height: 60,
                            width: 80,
                          ),
                          if (widget.isVideoList[index])
                            const Positioned.fill(
                              child: Center(
                                child: Icon(Icons.play_circle_fill,
                                    color: Colors.white, size: 24),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
