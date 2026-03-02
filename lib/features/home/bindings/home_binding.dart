import 'package:get/get.dart';
import 'package:real_estate_app/core/services/agent_services.dart';
import 'package:real_estate_app/core/services/home_services.dart';
import 'package:real_estate_app/core/services/property_services.dart';
import 'package:real_estate_app/features/agent/controllers/agent_controller.dart';
import 'package:real_estate_app/features/explore/controllers/explore_controller.dart';
import 'package:real_estate_app/features/property/controllers/property_controller.dart';
import 'package:real_estate_app/features/favorite/controllers/favorite_controller.dart';
import 'package:real_estate_app/features/home/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeServices());
    Get.put(PropertyServices(), permanent: true);
    Get.put(AgentServices(), permanent: true);

    Get.put(FavoriteController(), permanent: true);
    Get.put(HomeController());
    Get.put(AgentController());

    Get.lazyPut(() => ExploreController(), fenix: true);
    Get.lazyPut(() => PropertyController(), fenix: true);
  }
}
