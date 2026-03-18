import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';

class NavItem {
  final String icon;
  final String iconSelected;
  final String label;
  const NavItem({
    required this.icon,
    required this.iconSelected,
    required this.label,
  });
}

class BottomNav extends StatelessWidget {
  final List<NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    const baseHeight = 80.0;
    const circleRadius = 48.0;
    final itemWidth = size.width / items.length;

    // Center of the selected item
    final centerX = currentIndex * itemWidth + itemWidth / 2;
    // Left position of the circle so its center aligns with item center
    final indicatorLeft = (centerX - circleRadius / 2).roundToDouble();

    return Container(
      height: baseHeight + bottomPadding,
      color: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: baseHeight + 20,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
            ),
          ),

          // Floating indicator circle – now correctly vertically aligned
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            left: indicatorLeft,
            top: 0, // Adjusted to align center with selected icon
            child: Container(
              width: circleRadius,
              height: circleRadius,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
            ),
          ),

          // Navigation items (icons + labels) – aligned at bottom
          Positioned(
            bottom: bottomPadding + 6,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(items.length, (i) {
                final selected = i == currentIndex;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (!selected) {
                        HapticFeedback.mediumImpact();
                        onTap(i);
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Icon with animated scale and vertical lift
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.elasticOut,
                          margin: EdgeInsets.only(bottom: selected ? 25 : 8),
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 400),
                            scale: selected ? 1.1 : 1.0,
                            curve: Curves.elasticOut,
                            child: AppSvg(
                              path: selected
                                  ? items[i].iconSelected
                                  : items[i].icon,
                              width: 20,
                              color: selected
                                  ? AppColors.white
                                  : AppColors.white.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                        // Label
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: 12,
                            color: selected
                                ? AppColors.white
                                : AppColors.white.withValues(alpha: 0.6),
                          ),
                          child: Text(items[i].label),
                        ),
                        if (selected) const SizedBox(height: 4),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
