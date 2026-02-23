import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/explore/models/property_detail.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

class SavedAndChips extends StatelessWidget {
  final PropertyDetail property;
  const SavedAndChips({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //? chips
        _Chips(srt: property.propertyType.toString(), color: AppColors.primary),
        _Chips(srt: property.propertyMode.toString(), color: Colors.green),
        _Chips(
          srt: property.listingCategory.toString(),
          color: Colors.redAccent,
        ),
        const Spacer(),
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          ),
          icon: const Icon(Icons.favorite, color: AppColors.primary),
          onPressed: () {},
        ),
        //? saved
      ],
    );
  }
}

class _Chips extends StatelessWidget {
  final String srt;
  final Color color;
  const _Chips({required this.srt, this.color = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: AppText(
        srt.toString().split("_").map((e) => e.capitalizeFirst).join(" "),
        color: color,
        fontSize: 10,
      ),
    );
  }
}
