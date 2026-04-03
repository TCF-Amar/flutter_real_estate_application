import 'package:flutter/material.dart';
import 'package:real_estate_app/features/property/models/property_unit_model.dart';

class ViewPlan extends StatelessWidget {
  final PropertyUnitModel unit;

  const ViewPlan({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Header
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${unit.bhk ?? ""} BHK Plan",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              /// Floor Plan Image 🔥
              if (unit.floorPlanImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: 250,
                    child: InteractiveViewer(
                      panEnabled: true,
                      minScale: 1,
                      maxScale: 4,
                      child: Image.network(
                        unit.floorPlanImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("No Floor Plan Available"),
                ),

              const SizedBox(height: 12),

              /// Details
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _row("Unit No", unit.unitNumber),
                    _row("Price", unit.formattedPrice ?? "₹${unit.price}"),
                    _row("Area", "${unit.areaSqft ?? '-'} sqft"),
                    _row("Bedrooms", "${unit.bedrooms ?? '-'}"),
                    _row("Bathrooms", "${unit.bathrooms ?? '-'}"),
                    _row("Balcony", "${unit.balconyCount ?? '-'}"),
                    _row("Floor", "${unit.floor ?? '-'}"),
                    _row("Facing", unit.facing),
                    _row("Status", unit.status),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // /// CTA
              // Padding(
              //   padding: const EdgeInsets.all(16),
              //   child: SizedBox(
              //     width: double.infinity,
              //     child: ElevatedButton(
              //       onPressed: () {
              //         /// booking / contact flow
              //       },
              //       child: const Text("Book This Unit"),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(
            value ?? "-",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
