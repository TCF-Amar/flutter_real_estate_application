import 'dart:ui';
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

    // Total bar height (base bar + overflow)
    const baseHeight = 75.0;
    const circleRadius = 32.0;

    // Calculate the width of each item for positioning
    final itemWidth = size.width / items.length;

    return Container(
      height: baseHeight + bottomPadding,
      color: Colors.transparent, // Background through ClipPath or Stack
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // The Main Bar Background
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: baseHeight + bottomPadding,
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

          // The Raised Sliding Indicator
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            // curve: Curves.easeOutBack,
            left: (currentIndex * itemWidth) + (itemWidth / 2) - circleRadius,
            top: -20, // Negative top for raised effect
            child: Container(
              width: circleRadius * 2,
              height: circleRadius * 2,
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

          // Navigation Items (Icons and Labels)
          Positioned(
            bottom: bottomPadding + 8,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          // curve: Curves.easeOutBack,
                          margin: EdgeInsets.only(bottom: selected ? 32 : 6),
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 400),
                            scale: selected ? 1.25 : 1.0,
                            curve: Curves.bounceOut,
                            child: AppSvg(
                              path: selected
                                  ? items[i].iconSelected
                                  : items[i].icon,
                              width: 22,
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
                            fontSize: 11,
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: selected
                                ? AppColors.white
                                : AppColors.white.withValues(alpha: 0.6),
                          ),
                          child: Text(items[i].label),
                        ),
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
