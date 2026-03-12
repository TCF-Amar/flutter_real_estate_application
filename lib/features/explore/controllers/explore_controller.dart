import 'package:get/get.dart';
import 'package:real_estate_app/core/errors/failure.dart';
import 'package:logger/logger.dart';

class ExploreController extends GetxController {
  final Logger log = Logger();

  final RxInt selectedTabIndex = 0.obs;

  final Rxn<Failure> _error = Rxn<Failure>();
  Failure? get error => _error.value;

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }
}
