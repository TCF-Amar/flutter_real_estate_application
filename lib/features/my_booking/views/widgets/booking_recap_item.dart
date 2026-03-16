import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class BookingRecapItem extends StatelessWidget {
  final String? path;
  final IconData? icon;
  final String title;
  final String subtitle;

  const BookingRecapItem({
    super.key,
    this.path,
    this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: path != null
          ? AppSvg(path: path!, height: 15, width: 15, color: AppColors.grey)
          : Icon(icon, color: AppColors.grey),
      title: AppText(
        title,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      subtitle: AppText(subtitle, fontSize: 10, color: AppColors.textSecondary),
    );
  }
}
