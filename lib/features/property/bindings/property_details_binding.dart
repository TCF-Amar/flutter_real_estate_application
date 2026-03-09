import 'package:get/get.dart';
import 'package:real_estate_app/features/agent/controllers/agent_controller.dart';
import 'package:real_estate_app/features/property/controllers/property_details_controller.dart';

class PropertyDetailsBinding extends Bindings {
  @override
  void dependencies() {
    // AgentController may already be alive (registered by HomeBinding).
    // putIfAbsent pattern — only create if not yet registered.
    if (!Get.isRegistered<AgentController>()) {
      Get.lazyPut(() => AgentController(), fenix: true);
    }
    Get.lazyPut(() => PropertyDetailsController(), fenix: true);
  }
}
