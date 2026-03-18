import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/features/my_booking/models/visit_detail_response.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class VisitPropertyInfoSection extends StatelessWidget {
  final VisitProperty? property;
  const VisitPropertyInfoSection({super.key, this.property});

  @override
  Widget build(BuildContext context) {
    if (property == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const AppTag(label: "Featured", color: Colors.amber),
                const SizedBox(width: 10),
                AppTag(
                  label: property?.propertyTypeLabel ?? "",
                  color: Colors.green,
                ),
                const SizedBox(width: 10),
                AppTag(
                  label: property?.listingCategory ?? "",
                  color: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 18),
            AppText.large(property?.title ?? ""),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSvg(path: Assets.icons.location, height: 16),
                const SizedBox(width: 10),
                Flexible(
                  child: AppText(
                    property?.address ?? "",
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            AppText.large(
              "\$ ${property?.price ?? 0}",
              color: AppColors.primary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}
