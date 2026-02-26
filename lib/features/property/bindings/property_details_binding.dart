import 'package:get/get.dart';
import 'package:real_estate_app/features/property/controllers/property_details_controller.dart';

class PropertyDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PropertyDetailsController());
  }
}
