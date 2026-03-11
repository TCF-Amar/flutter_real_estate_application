import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
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
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.supportDetails, arguments: t);
      },
      child: AppContainer(
        padding: const EdgeInsets.all(16),
        showBorder: true,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AppText(t.title!, fontSize: 14, color: AppColors.textSecondary),
                SizedBox(height: 4),
                AppText(
                  "Ticket ID: ${t.id?.toUpperCase()}",
                  fontSize: 12,
                  color: AppColors.textSecondary,
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
                  fontSize: 12,
                  color: color,
                ),
                SizedBox(height: 4),
                AppText(
                  "Date: ${t.date}",
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
