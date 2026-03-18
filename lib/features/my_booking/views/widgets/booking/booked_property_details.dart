import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/my_booking/models/booking_detail_model.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/booking/booked_units/index.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class BookedPropertyDetails extends StatelessWidget {
  final BookedPropertyDetail property;
  const BookedPropertyDetails({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: AppContainer(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                property.isFeatured == true
                    ? AppTag(label: "Featured")
                    : AppTag(label: "${property.propertyCategory}"),
                SizedBox(width: 8),
                AppTag(
                  label: "${property.propertyType}",
                  color: AppColors.success,
                ),
              ],
            ),
            SizedBox(height: 16),
            AppText.large("${property.title}"),
            SizedBox(height: 8),
            Row(
              children: [
                AppSvg(path: Assets.icons.location),
                SizedBox(width: 4),
                AppText.small("${property.address}"),
              ],
            ),
            SizedBox(height: 16),
            BookedUnits(property: property),
          ],
        ),
      ),
    );
  }
}
