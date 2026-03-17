import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/constants/environments.dart';
import 'package:real_estate_app/features/property/models/property_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class VideoPreview extends StatefulWidget {
  final List<MediaItem> videos;

  const VideoPreview({super.key, required this.videos});

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  int _currentIndex = 0;

  String get _currentUrl =>
      Environments.baseUrl + widget.videos[_currentIndex].url;

  void _prev() {
    if (_currentIndex > 0) setState(() => _currentIndex--);
  }

  void _next() {
    if (_currentIndex < widget.videos.length - 1) {
      setState(() => _currentIndex++);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.videos.isEmpty) return const SizedBox.shrink();

    final total = widget.videos.length;
    final hasPrev = _currentIndex > 0;
    final hasNext = _currentIndex < total - 1;

    return Container(
      margin: const EdgeInsets.only(top: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header + counter ──────────────────────────────────
          Row(
            children: [
              AppText.large("Videos"),
              const Spacer(),
              if (total > 1)
                AppText(
                  "${_currentIndex + 1} / $total",
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Player ───────────────────────────────────────────
          AppVideoPlayer(key: ValueKey(_currentUrl), url: _currentUrl),

          // ── Prev / Next controls ─────────────────────────────
          if (total > 1) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                // Prev
                _NavButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  label: "Previous",
                  onTap: hasPrev ? _prev : null,
                ),
                const Spacer(),

                // Dot indicators
                Row(
                  children: List.generate(total, (i) {
                    final active = i == _currentIndex;
                    return GestureDetector(
                      onTap: () => setState(() => _currentIndex = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        height: 7,
                        width: active ? 18 : 7,
                        decoration: BoxDecoration(
                          color: active
                              ? AppColors.primary
                              : AppColors.primary.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }),
                ),

                const Spacer(),

                // Next
                _NavButton(
                  icon: Icons.arrow_forward_ios_rounded,
                  label: "Next",
                  onTap: hasNext ? _next : null,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _NavButton({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.3,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon == Icons.arrow_back_ios_new_rounded) ...[
                Icon(icon, size: 12, color: AppColors.primary),
                const SizedBox(width: 4),
              ],
              AppText(
                label,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
              if (icon == Icons.arrow_forward_ios_rounded) ...[
                const SizedBox(width: 4),
                Icon(icon, size: 12, color: AppColors.primary),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
