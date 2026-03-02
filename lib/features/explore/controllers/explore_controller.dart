import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ExploreController extends GetxController {
  final Logger log = Logger();

  final RxInt selectedTabIndex = 0.obs;

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }
}
