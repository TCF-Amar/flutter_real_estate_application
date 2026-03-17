import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/agent/controllers/agent_details_controller.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class ListedProperty extends StatefulWidget {
  const ListedProperty({super.key});

  @override
  State<ListedProperty> createState() => _ListedPropertyState();
}

class _ListedPropertyState extends State<ListedProperty> {
  final controller = Get.find<AgentDetailsController>();
  int _activeFilterIndex = 0;

  final List<String> _filters = ['All', 'For Sale', 'For Rent'];

  @override
  void initState() {
    super.initState();
    _activeFilterIndex = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.filterProperties(_filters[_activeFilterIndex]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             AppText.large("Listed Properties"),
            const SizedBox(height: 16),
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final isSelected = _activeFilterIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _activeFilterIndex = index);
                      controller.filterProperties(_filters[index]);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.grey.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: AppText(
                        _filters[index],
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Obx(() {
              final error = controller.error;
              if (error != null) {
                return Center(child: AppText(error.message));
              }
              if (controller.agentDetails?.properties.isEmpty ?? true) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: AppText(
                      "No properties listed by this agent.",
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              }

              if (controller.filterPropertiesList.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: AppText(
                      "No properties found for this filter.",
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              }

              return ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.filterPropertiesList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final property = controller.filterPropertiesList[index];
                  return ModernPropertyCard(
                    property: property,
                    onToggleFavorite: () {
                      controller.updatePropertyFavorite(property.id);
                    },
                  );
                },
              );
            }),
            const SizedBox(height: 16),
            Obx(
              () => controller.isLastPage
                  ? const SizedBox.shrink()
                  : Center(
                      child: LoadMoreButton(
                        onPressed: () => controller.loadMoreProperties(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
