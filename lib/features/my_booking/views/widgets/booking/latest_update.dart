import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/my_booking/models/booking_detail_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class LatestUpdateSection extends StatefulWidget {
  final UpdateItem update;
  const LatestUpdateSection({super.key, required this.update});

  @override
  State<LatestUpdateSection> createState() => _LatestUpdateSectionState();
}

class _LatestUpdateSectionState extends State<LatestUpdateSection> {
  late PageController _pageController;
  final _currentPage = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: AppContainer(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.large(
              "Latest Update",
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 16),
            AppContainer(
              showBorder: true,
              borderColor: AppColors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.update.images.isNotEmpty) ...[
                    SizedBox(
                      height: 180,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            PageView.builder(
                              controller: _pageController,
                              onPageChanged: (index) =>
                                  _currentPage.value = index,
                              itemCount: widget.update.images.length,
                              itemBuilder: (context, index) {
                                return AppImage(
                                  path: widget.update.images[index].url,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                            // Navigation Arrows
                            PositionDetector(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildArrow(
                                    Icons.chevron_left,
                                    onTap: () {
                                      _pageController.previousPage(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                  ),
                                  _buildArrow(
                                    Icons.chevron_right,
                                    onTap: () {
                                      _pageController.nextPage(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            // Dots Indicator
                            Positioned(
                              bottom: 12,
                              left: 0,
                              right: 0,
                              child: ValueListenableBuilder<int>(
                                valueListenable: _currentPage,
                                builder: (context, current, _) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: widget.update.images
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                          return AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            width: entry.key == current
                                                ? 16
                                                : 8,
                                            height: 8,
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: entry.key == current
                                                  ? Colors.white
                                                  : Colors.white.withValues(
                                                      alpha: 0.5,
                                                    ),
                                            ),
                                          );
                                        })
                                        .toList(),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  AppText(
                    widget.update.date ?? '',
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                  const SizedBox(height: 8),
                  AppText.large(
                    widget.update.title ?? 'N/A',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 12),
                  if (widget.update.description != null)
                    ...widget.update.description!
                        .split('\n')
                        .where((s) => s.trim().isNotEmpty)
                        .map(
                          (line) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Container(
                                    width: 5,
                                    height: 5,
                                    decoration: const BoxDecoration(
                                      color: AppColors.textSecondary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: AppText(
                                    line.trim().replaceAll(
                                      RegExp(r'^[-•*]\s*'),
                                      '',
                                    ),
                                    color: AppColors.textSecondary,
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArrow(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}

class PositionDetector extends StatelessWidget {
  final Widget child;
  const PositionDetector({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(child: Center(child: child));
  }
}
