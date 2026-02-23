import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/explore/models/address.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';
import 'package:real_estate_app/features/shared/widgets/header_text.dart';

class Address extends StatelessWidget {
  final AddressModel address;
  const Address({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderText(
            text: "Address",
            // fontSize: 18,
            // fontWeight: FontWeight.bold,
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),

            child: Column(
              children: [
                _buildAddressRow(
                  "Address:",
                  "${address.line1 ?? "N/A"} ${address.line2 ?? ""}",
                ),
                _buildAddressRow("City:", address.city ?? "N/A"),
                _buildAddressRow("Area:", address.locality ?? "N/A"),
                _buildAddressRow("State/County:", address.state ?? "N/A"),
                _buildAddressRow("Zip/Postal Code:", address.zipcode ?? "N/A"),
                _buildAddressRow("Country:", address.country ?? "N/A"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // build adrees row
  Widget _buildAddressRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        // border only bottom
        border: Border(
          bottom: BorderSide(color: AppColors.grey.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(label),
          // Spacer(),
          const SizedBox(width: 10),
          Expanded(
            child: AppText(
              value,
              textAlign: TextAlign.right,
              // maxLines: 2,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
