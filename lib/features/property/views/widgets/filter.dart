import 'package:flutter/material.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

class Filter extends StatelessWidget {
  const Filter({super.key});

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: [true, false, false],
      onPressed: (index) {},
      children: [
        AppText("All"),
        AppText("For Sale"),
        AppText("For Rent"),
      ],
    );
  }
}
