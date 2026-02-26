import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/property/models/property_detail_model.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

class Title extends StatelessWidget {
  final PropertyDetail property;
  const Title({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            property.title.toString(),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          AppText(
            property.configurationName.toString(),
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: AppColors.grey,
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on, color: AppColors.grey, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: AppText(
                  "${property.address!.zipcode} ${property.address!.locality}, ${property.address!.city} ${property.address!.state}, ${property.address!.country}",
                  fontSize: 12,
                  overflow: TextOverflow.clip,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
//AppText(
                    //   "${property.title.toString()} ${property.id.toString()}",
                    //   fontSize: 18,
                    //   fontWeight: FontWeight.w500,
                    //   maxLines: 2,
                    //   overflow: TextOverflow.ellipsis,
                    // ),