import 'package:get/get.dart';
import 'package:real_estate_app/features/search/controllers/search_controller.dart';

class SearchBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AppSearchController());
  }
}
