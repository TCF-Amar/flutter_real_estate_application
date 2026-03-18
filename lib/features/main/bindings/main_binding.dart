import 'package:get/get.dart';
import 'package:real_estate_app/features/agent/controllers/agent_controller.dart';
import 'package:real_estate_app/features/auth/controllers/auth_controller.dart';
import 'package:real_estate_app/features/explore/controllers/explore_controller.dart';
import 'package:real_estate_app/features/favorite/controllers/favorite_controller.dart';
import 'package:real_estate_app/features/home/controllers/home_controller.dart';
import 'package:real_estate_app/features/main/controllers/main_controller.dart';
import 'package:real_estate_app/features/my_booking/controllers/my_booking_controller.dart';
import 'package:real_estate_app/features/profile/controllers/maintenance_controller.dart';
import 'package:real_estate_app/features/profile/controllers/profile_controller.dart';
import 'package:real_estate_app/features/property/controllers/property_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // AuthController is registered permanently so user data is accessible
    // from any screen (Profile, Home, etc.) without re-fetching.
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.lazyPut<MainController>(() => MainController());

    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => AgentController(), fenix: true);

    Get.lazyPut(() => FavoriteController(), fenix: true);
    Get.lazyPut(() => ExploreController(), fenix: true);
    Get.lazyPut(() => PropertyController(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
    Get.lazyPut(() => MyBookingController(), fenix: true);
    Get.lazyPut(() => MaintenanceController(), fenix: true);
  }
}
