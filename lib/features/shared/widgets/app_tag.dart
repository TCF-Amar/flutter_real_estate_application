import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class AppTag extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? backgroundColor;

  const AppTag({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor ?? c.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: c),
            const SizedBox(width: 3),
          ],
          AppText(
            _formatLabel(label),
            fontSize: fontSize ?? 8,
            color: c,
            fontWeight: fontWeight ?? FontWeight.w600,
          ),
        ],
      ),
    );
  }

  String _formatLabel(String raw) {
    return raw
        .split('_')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }
}
