import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/profile/controllers/maintenance_controller.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class MaintenanceTabSwitcher extends GetView<MaintenanceController> {
  const MaintenanceTabSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Obx(
        () => AppContainer(
          padding: const EdgeInsets.all(4),
          showBorder: true,
          borderColor: AppColors.grey.withValues(alpha: 0.3),
          child: Row(
            children: [
              _TabItem(
                label: "Active",
                count: controller.activeRequests.length,
                isSelected: controller.selectedTabIndex.value == 0,
                onTap: () => controller.selectedTabIndex.value = 0,
              ),
              const SizedBox(width: 12),
              _TabItem(
                label: "Past",
                count: controller.pastRequests.length,
                isSelected: controller.selectedTabIndex.value == 1,
                onTap: () => controller.selectedTabIndex.value = 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                label,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
