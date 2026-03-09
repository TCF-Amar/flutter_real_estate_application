import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/shared/widgets/app_container.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

enum PaymentStatus { pending, paid, failed }

class TicketData {
  String? title;
  String? id;
  String? date;
  PaymentStatus? status;

  TicketData({this.title, this.id, this.date, this.status});
}

class TicketCard extends StatelessWidget {
  final TicketData t;
  const TicketCard({super.key, required this.t});

  Color get color {
    switch (t.status) {
      case PaymentStatus.pending:
        return Colors.orange.shade500;
      case PaymentStatus.paid:
        return Colors.green.shade500;
      case PaymentStatus.failed:
        return Colors.red.shade500;
      case null:
        return Colors.grey.shade500;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.all(16),
      showBorder: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AppText(
                t.title!,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
              SizedBox(height: 4),
              AppText(
                "Ticket ID: ${t.id?.toUpperCase()}",
                fontSize: 10,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AppText(
                "${t.status!.name.capitalize} ",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: color,
              ),
              SizedBox(height: 4),
              AppText(
                "Date: ${t.date}",
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
