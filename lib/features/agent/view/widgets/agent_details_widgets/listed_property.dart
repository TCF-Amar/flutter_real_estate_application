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
    controller.filterProperties(_filters[_activeFilterIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderText(text: "Listed Properties"),
            SizedBox(
              height: 35,
              child: ListView.separated(
                padding: const EdgeInsets.only(top: 10),
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final isSelected = _activeFilterIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _activeFilterIndex = index);
                      controller.filterProperties(_filters[index]);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.grey.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: AppText(
                            _filters[index],
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: isSelected ? Colors.white : AppColors.grey,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // const SizedBox(height: 20),
            controller.agentDetails!.properties.isEmpty
                ? const AppText(
                    "No properties listed yet.",
                    color: AppColors.textSecondary,
                  )
                : Obx(() {
                    if (controller.filterPropertiesList.isEmpty) {
                      return const AppText(
                        "No properties listed yet.",
                        color: AppColors.textSecondary,
                      );
                    }
                    return ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.filterPropertiesList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
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

            Obx(
              () => controller.isLastPage
                  ? SizedBox.shrink()
                  : LoadMoreButton(
                      onPressed: () => controller.loadMoreProperties(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
