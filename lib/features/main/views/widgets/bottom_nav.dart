import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

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
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.only(top: 0, bottom: bottom + 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(items.length, (i) {
          final selected = i == currentIndex;
          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              onTap(i);
            },
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: selected ? -10.0 : 0.0),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  builder: (_, offset, child) => Transform.translate(
                    offset: Offset(0, offset),
                    child: child,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    padding: selected
                        ? const EdgeInsets.all(14)
                        : const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 15,
                                spreadRadius: 2,
                                offset: const Offset(0, 8),
                              ),
                            ]
                          : [],
                    ),
                    child: SvgPicture.asset(
                      selected ? items[i].iconSelected : items[i].icon,
                      width: 20,
                    ),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: selected ? 1.0 : 0.5,
                  child: AppText(
                    items[i].label,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
