import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class BookingStatusTag extends StatelessWidget {
  final String status;
  final String label;

  const BookingStatusTag({
    super.key,
    required this.status,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: AppText(
        label == "Requested" ? "Pending" : label,
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'requested':
      case 'pending':
        return const Color(0xFFFFC107); // Amber/Yellow
      case 'confirmed':
        return Colors.green;
      case 'canceled':
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.primary;
    }
  }
}
