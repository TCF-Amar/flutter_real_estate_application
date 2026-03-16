import 'package:get/instance_manager.dart';
import 'package:real_estate_app/features/my_booking/controllers/visit_details_controller.dart';

class VisitDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(VisitDetailsController());
  }
}
