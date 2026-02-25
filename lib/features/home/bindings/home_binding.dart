import 'package:get/instance_manager.dart';
import 'package:real_estate_app/core/services/home_services.dart';
import 'package:real_estate_app/core/services/explore_services.dart';
import 'package:real_estate_app/features/explore/controllers/explore_controller.dart';
import 'package:real_estate_app/features/explore/controllers/agent_controller.dart';
import 'package:real_estate_app/features/saved_properties/controllers/saved_properties_controller.dart';
import 'package:real_estate_app/features/home/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SavedPropertiesController());
    Get.lazyPut(() => HomeServices());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => ExploreServices());
    Get.lazyPut(() => ExploreController());
    Get.lazyPut(() => ExploreController(), fenix: true);
    Get.lazyPut(() => AgentController());
  }
}
