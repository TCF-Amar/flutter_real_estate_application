import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/explore/models/property_model.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';
import 'package:real_estate_app/features/shared/widgets/header_text.dart';

class AmenitiesFeatures extends StatefulWidget {
  final List<Amenity> amenities;
  const AmenitiesFeatures({super.key, required this.amenities});

  @override
  State<AmenitiesFeatures> createState() => _AmenitiesFeaturesState();
}

class _AmenitiesFeaturesState extends State<AmenitiesFeatures> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderText(text: "Amenities & Features"),
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 0,
              ),
              itemCount: _isExpanded
                  ? widget.amenities.length
                  : widget.amenities.length > 10
                  ? 10
                  : widget.amenities.length,
              itemBuilder: (context, index) {
                return _buildAmenitiesRow(widget.amenities[index].name);
              },
            ),
          ),
          if (widget.amenities.length > 10)
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.centerLeft,
                foregroundColor: AppColors.primary,
                // textStyle: const TextStyle(fontSize: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Text(_isExpanded ? "Show Less" : "Show More"),
            ),
        ],
      ),
    );
  }

  Widget _buildAmenitiesRow(String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.circle,
            size: 5,
            color: AppColors.grey.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AppText(
              value,
              fontSize: 13,
              color: AppColors.black.withValues(alpha: 0.8),
              maxLines: 1,
              overflow: TextOverflow.clip,
            ),
          ),
        ],
      ),
    );
  }
}
