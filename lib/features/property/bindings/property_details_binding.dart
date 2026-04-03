import 'package:get/get.dart';
import 'package:real_estate_app/features/agent/controllers/agent_controller.dart';
import 'package:real_estate_app/features/favorite/controllers/favorite_controller.dart';
import 'package:real_estate_app/features/property/controllers/property_details_controller.dart';

class PropertyDetailsBinding extends Bindings {
  @override
  void dependencies() {
   
    if (!Get.isRegistered<AgentController>()) {
      Get.lazyPut(() => AgentController(), fenix: true);
    }
    if (!Get.isRegistered<FavoriteController>()) {
      Get.lazyPut(() => FavoriteController(), fenix: true);
    }
   
    Get.put(PropertyDetailsController(), permanent: false);
  }
}
