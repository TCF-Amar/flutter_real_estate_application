import 'package:flutter/material.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class BookedPropertiesTab extends StatelessWidget {
  const BookedPropertiesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: const AppEmptyState(
        title: "No Bookings Found",
        message: "You haven't made any property bookings yet.",
      ),
    );
  }
}
