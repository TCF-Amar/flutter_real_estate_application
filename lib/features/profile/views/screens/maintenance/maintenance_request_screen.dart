import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/features/profile/controllers/maintenance_controller.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';
import 'widgets/index.dart';

class MaintenanceRequestScreen extends GetView<MaintenanceController> {
  final int? propertyId;
  final String? propertyTitle;
  final bool? isEnable;
  const MaintenanceRequestScreen({
    super.key,
    this.propertyId,
    this.propertyTitle,
    this.isEnable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const DefaultAppBar(title: "Report an Issue", actions: []),
      body: SafeArea(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PropertySelectDropdown(
                    propertyId: propertyId,
                    propertyTitle: propertyTitle,
                  ),
                  const SizedBox(height: 15),
                  const IssueDetailForm(),
                  const SizedBox(height: 15),
                  const MediaUploadSection(),
                  const SizedBox(height: 20),
                  AppButton(
                    text: "Send request",
                    onPressed: () {
                      controller.sendMaintenanceRequest();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
