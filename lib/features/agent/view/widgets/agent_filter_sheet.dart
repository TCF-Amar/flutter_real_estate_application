import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/agent/controllers/agent_controller.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class AgentFilterSheet extends StatelessWidget {
  const AgentFilterSheet({super.key});

  static const _ratingOptions = [
    '5 stars',
    '4 stars',
    '3 stars',
    '2 stars',
    '1 stars',
  ];

  static const List<Map<String, dynamic>> _experienceOptions = [
    {'label': '1-3 Years', 'value': '1-3'},
    {'label': '3-5 Years', 'value': '3-5'},
    {'label': '5-10 Years', 'value': '5-10'},
    {'label': '10+ Years', 'value': '10+'},
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AgentController>();

    return Container(
      margin: const EdgeInsets.only(top: 100),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 50),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Handle bar ────────────────────────────────
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Header ────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppText(
                'Filter',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              IconButton(
                icon: const Icon(Icons.cancel, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 16),

          // ── Scrollable body ───────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location ──────────────────────────
                  const AppText(
                    'Location',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: controller.location.value,
                    onChanged: (v) => controller.location.value = v,
                    decoration: InputDecoration(
                      hintText: 'Search by location or city',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Rating ────────────────────────────
                  const AppText(
                    'Rating',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _ratingOptions.map((rating) {
                        final isSelected = controller.rating.value == rating;
                        return ChoiceChip(
                          label: AppText(rating),
                          selected: isSelected,
                          onSelected: (_) => controller.rating.value = rating,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey,
                          ),
                          backgroundColor: Colors.grey[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide.none,
                          ),
                          showCheckmark: false,
                          avatar: isSelected
                              ? const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Experience ────────────────────────
                  const AppText(
                    'Experience',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 8),
                  Obx(() {
                    final storedValue = controller.experience.value;
                    final matchedOption = storedValue.isNotEmpty
                        ? _experienceOptions.firstWhereOrNull(
                            (e) => e['value'] == storedValue,
                          )
                        : null;
                    final initialLabel = matchedOption?['label'] as String?;

                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownFlutter<String>(
                          items: [
                            ..._experienceOptions.map(
                              (e) => e['label'] as String,
                            ),
                          ],
                          initialItem: initialLabel,
                          onChanged: (label) {
                            if (label == null) return;
                            final match = _experienceOptions.firstWhereOrNull(
                              (e) => e['label'] == label,
                            );
                            if (match != null) {
                              controller.experience.value =
                                  match['value'] as String;
                            }
                          },
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // ── Footer buttons ────────────────────────────
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.clearFilters,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const AppText('Reset', color: AppColors.textPrimary),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.applyFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const AppText('Apply', color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
