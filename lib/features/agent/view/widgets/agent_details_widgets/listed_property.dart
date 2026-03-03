import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/agent/controllers/agent_details_controller.dart';
import 'package:real_estate_app/features/property/models/property_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';
import 'package:real_estate_app/features/shared/widgets/load_more_button.dart';

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
                        return ModernPropertyCard(property: property);
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

class ModernPropertyCard extends StatelessWidget {
  final Property property;

  const ModernPropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.propertyDetails,
        arguments: {"id": property.id},
      ),
      // margin: const EdgeInsets.all(0),
      child: SizedBox(
        height: 240,
        // decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
        child: Stack(
          children: [
            /// PROPERTY IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AppImage(
                path: property.media.images.isNotEmpty == true
                    ? property.media.images.first.url
                    : null,
                width: double.infinity,
                height: 240,
                fit: BoxFit.cover,
              ),
            ),

            /// GRADIENT OVERLAY
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            /// TOP TAGS
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      AppTag(
                        label: property.propertyType,
                        backgroundColor: Colors.white,
                        fontSize: 9,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 6),
                      AppTag(
                        label: "${property.listingCategory}",
                        backgroundColor: Colors.white,
                        fontSize: 9,
                        color: Colors.amber,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: CircleAvatar(
                      radius: 20,
                      child: AppSvg(
                        path: Assets.icons.heart,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// BOTTOM INFO CARD
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// TEXTS
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              "${property.locality}, ${property.state}",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),

                    /// PRICE
                    Text(
                      "${property.formattedPrice}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
