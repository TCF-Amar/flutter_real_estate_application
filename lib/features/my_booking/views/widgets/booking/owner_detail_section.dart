import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/agent/models/agent_model.dart';
import 'package:real_estate_app/features/my_booking/models/booking_detail_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class OwnerDetailSection extends StatelessWidget {
  final OwnerDetail owner;
  const OwnerDetailSection({super.key, required this.owner});

  @override
  Widget build(BuildContext context) {
    bool isAgent = owner.type?.toLowerCase() == 'agent';

    return SliverToBoxAdapter(
      child: AppContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.large(
              isAgent ? "Marked as Agent" : "Developer Information",
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 16),
            if (isAgent)
              ExploreAgentCard(agent: AgentModel.fromJson(owner.toJson()))
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.grey.withValues(alpha: 0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Top Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar or Logo
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.grey.withValues(alpha: 0.1),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: AppImage(
                              path: owner.image ?? '',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                owner.name ?? '',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              const SizedBox(height: 4),
                              // Assuming description might hold some subtile or we just show a placeholder "Mumbai" if there is no specific field
                              const AppText(
                                "Real Estate Developer",
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                              if (owner.description != null &&
                                  owner.description!.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                AppText(
                                  owner.description!.length > 30
                                      ? "\${owner.description!.substring(0, 30)}..."
                                      : owner.description!,
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ],
                            ],
                          ),
                        ),
                        // Heart Icon
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withValues(alpha: 0.05),
                          ),
                          child: const Icon(
                            Icons.favorite_border,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Bottom Row
                    Row(
                      children: [
                        // Projects
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.home,
                                  color: AppColors.grey.withValues(alpha: 0.5),
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                AppText(
                                  "\${owner.propertiesCount ?? 0} projects",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const AppText(
                              "Total",
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                        const SizedBox(width: 24),
                        // Experience
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.business_center,
                                  color: AppColors.grey.withValues(alpha: 0.5),
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                AppText(
                                  owner.experience ?? "N/A",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const AppText(
                              "Experience",
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                        const Spacer(),
                        AppButton(
                          text: "View detail",
                          width: 110,
                          // height: 36,
                          fontSize: 13,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
