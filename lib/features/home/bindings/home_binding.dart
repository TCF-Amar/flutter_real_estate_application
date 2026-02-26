import 'package:get/get.dart';
import 'package:real_estate_app/core/services/home_services.dart';
import 'package:real_estate_app/core/services/explore_services.dart';
import 'package:real_estate_app/features/explore/controllers/agent_controller.dart';
import 'package:real_estate_app/features/explore/controllers/explore_controller.dart';
import 'package:real_estate_app/features/property/controllers/property_controller.dart';
import 'package:real_estate_app/features/saved/controllers/favorite_controller.dart';
import 'package:real_estate_app/features/home/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Services first — no dependencies
    Get.put(HomeServices());
    Get.put(ExploreServices(), permanent: true);
    Get.put(FavoriteController(), permanent: true);

    // 2. Controllers that only depend on services
    Get.put(HomeController());
    Get.put(AgentController(), permanent: true);

    // 3. Lazy controllers (created on first Get.find, ExploreServices already up)
    Get.lazyPut(() => ExploreController(), fenix: true);
    Get.lazyPut(() => PropertyController(), fenix: true);

    // 4. FavoriteController last — needs ExploreServices, HomeController, ExploreController
  }
}
