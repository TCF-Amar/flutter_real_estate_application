import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/profile/views/widgets/support_widgets/ticket_card.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class SupportDetails extends StatelessWidget {
  const SupportDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final status = PaymentStatus.pending;
    return Scaffold(
      appBar: DefaultAppBar(title: "Support Detail"),

      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                AppContainer(child: Center(child: _buildStatus(status))),

                SizedBox(height: 10),

                AppContainer(
                  // width: double.infinity,
                  color: AppColors.primary.withValues(alpha: 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText("Ticket Info.", fontWeight: .w600, fontSize: 16),

                      SizedBox(height: 18),
                      Row(
                        children: [
                          AppText("Ticket ID: ", fontSize: 15),
                          Spacer(),
                          AppText(
                            "123456789",
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Divider(color: AppColors.primary.withValues(alpha: 0.08)),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          AppText("issue Type: ", fontSize: 15),
                          Spacer(),
                          AppText(
                            "Payment Issue",
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Divider(color: AppColors.primary.withValues(alpha: 0.08)),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          AppText("Submit On: ", fontSize: 15),
                          Spacer(),
                          AppText(
                            "12/12/2022",
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Divider(color: AppColors.primary.withValues(alpha: 0.08)),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          AppText("Last Updated: ", fontSize: 15),
                          Spacer(),
                          AppText(
                            "12/12/2022",
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Divider(color: AppColors.primary.withValues(alpha: 0.08)),
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText("Description", fontSize: 15),
                          SizedBox(height: 10),
                          AppText(
                            "yaha pe discription hoga mera naam amarjeet hai mai yaha se nahi hu main woha se hu mai yaha kaam karta hu ",
                            overflow: TextOverflow.visible,
                            textAlign: .justify,
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18),
                AppContainer(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      AppText.large("Admin Response", fontSize: 16),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          AppText("Response Date: ", fontSize: 14),
                          Spacer(),
                          AppText(
                            "12 Dec 2022 12:12:12 PM",
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Divider(color: AppColors.primary.withValues(alpha: 0.08)),
                      SizedBox(height: 10),
                      AppText(
                        'We’ve checked your payment and confirmed it’s under processing. You’ll receive confirmation within 24 hours.',
                        overflow: TextOverflow.visible,
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        textAlign: .justify,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatus(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return _buildStatusCard(
          Colors.yellow,
          Icons.watch_later_outlined,
          status.name,
        );
      case PaymentStatus.paid:
        return _buildStatusCard(Colors.green, Icons.check_circle, status.name);
      case PaymentStatus.failed:
        return _buildStatusCard(Colors.red, Icons.warning_rounded, status.name);
    }
  }

  Widget _buildStatusCard(Color color, IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          radius: 32,
          child: CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.2),
            radius: 24,
            child: Icon(icon, size: 20, color: color),
          ),
        ),
        const SizedBox(height: 12),
        AppText(label, fontSize: 16, color: color),
      ],
    );
  }
}
