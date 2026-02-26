import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ExploreController extends GetxController {
  //* Dependencies
  final Logger log = Logger();

  //* Navigation & Search State
  final RxInt selectedTabIndex = 0.obs;

  //* Tab & Status Filter Management
  void changeTab(int index) {
    selectedTabIndex.value = index;
  }
}
