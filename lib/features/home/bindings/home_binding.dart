import 'package:get/instance_manager.dart';
import 'package:real_estate_app/core/services/home_services.dart';
import 'package:real_estate_app/core/services/property_services.dart';
import 'package:real_estate_app/features/explore/controllers/explore_controller.dart';
import 'package:real_estate_app/features/home/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeServices());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => PropertyServices());
    Get.lazyPut(() => ExploreController());
  }
}
