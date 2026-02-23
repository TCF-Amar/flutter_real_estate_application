import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/features/saved_properties/controllers/saved_properties_controller.dart';

class SavedScreen extends GetView<SavedPropertiesController> {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("Saved Properties"),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.savedProperties.length,
                  itemBuilder: (context, index) {
                    final savedProperty = controller.savedProperties[index];
                    return ListTile(title: Text(savedProperty.city.toString()));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
