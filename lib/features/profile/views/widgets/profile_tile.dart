import 'package:flutter/material.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class ProfileTile extends StatelessWidget {
  final String icon;
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback action;
  const ProfileTile({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.textColor,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),

      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: color.withValues(alpha: 0.1),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: AppSvg(path: icon, color: color),
      ),
      title: AppText(label, color: textColor),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),

      onTap: action,
    );
  }
}
