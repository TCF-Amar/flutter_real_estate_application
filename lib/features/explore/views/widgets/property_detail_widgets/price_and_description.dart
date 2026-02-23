import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/utils/date_time_utils.dart';
import 'package:real_estate_app/features/explore/models/property_detail.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';
import 'package:real_estate_app/features/shared/widgets/header_text.dart';

class PriceAndDescription extends StatefulWidget {
  final PropertyDetail property;
  const PriceAndDescription({super.key, required this.property});

  @override
  State<PriceAndDescription> createState() => _PriceAndDescriptionState();
}

class _PriceAndDescriptionState extends State<PriceAndDescription> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            widget.property.isNotCompleted
                ? widget.property.priceRange?.toString() ?? 'Price on request'
                : widget.property.formattedPrice?.toString() ??
                      widget.property.basePrice?.toString() ??
                      'N/A',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
          const SizedBox(height: 14),
          if (widget.property.isNotCompleted) ...[
            _buildInfoRow("Developer", widget.property.developerName),
            _buildInfoRow("Status", widget.property.status),
            _buildInfoRow(
              "Possession Date",
              DateTimeUtils.formatMonthYear(widget.property.possessionDate),
            ),
            const SizedBox(height: 14),
          ],

          Container(
            // margin: const EdgeInsets.only(top: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderText(
                  text: "Property Description",
                  // fontSize: 16,
                  // fontWeight: FontWeight.bold,
                  // color: AppColors.black.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        widget.property.description.toString(),
                        fontSize: 12,
                        maxLines: _isExpanded ? null : 5,
                        fontWeight: FontWeight.w400,
                        overflow: _isExpanded
                            ? TextOverflow.clip
                            : TextOverflow.ellipsis,
                      ),
                      if (widget.property.description != null &&
                          widget.property.description!.length > 150)
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: AppText(
                              _isExpanded ? "Show Less" : "Show More",
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  //
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: AppText(
              "$label: ",
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AppText(
              value?.toString() ?? "N/A",
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
