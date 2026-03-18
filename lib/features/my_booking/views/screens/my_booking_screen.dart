import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/my_booking/controllers/my_booking_controller.dart';
import 'package:real_estate_app/features/my_booking/views/screens/booked_properties_tab.dart';
import 'package:real_estate_app/features/my_booking/views/screens/visit/site_visits_screen.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class MyBookingScreen extends GetView<MyBookingController> {
  const MyBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = ["Site Visit", "Booked Properties"];
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(title: AppText.large("My Booking"), centerTitle: true),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Container(
                height: 55,
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.5),
                  ),
                ),
                child: TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.primary,
                  ),
                  tabs: tabs.map((tab) => Tab(text: tab)).toList(),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [SiteVisitsTab(), BookedPropertiesTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
