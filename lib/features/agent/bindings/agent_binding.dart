import 'package:get/get.dart';
import 'package:real_estate_app/features/agent/controllers/agent_details_controller.dart';

class AgentDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AgentDetailsController());
  }
}
