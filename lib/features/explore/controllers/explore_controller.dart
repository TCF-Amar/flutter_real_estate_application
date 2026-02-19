import 'package:get/get.dart';
import 'package:real_estate_app/core/services/property_services.dart';
import 'package:real_estate_app/features/explore/models/property_filter_model.dart';

class ExploreController extends GetxController {
  final PropertyServices propertyServices = Get.find<PropertyServices>();
  final RxInt selectedTabIndex = 0.obs;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final List<String> propertyFilters = [
    "All",
    "Ready to move",
    "Under Construction",
  ];

  final Rx<PropertyFilterModel?> filterData = Rx<PropertyFilterModel?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchFilterData();
  }

  void fetchFilterData() async {
    await _fetchFilterData();
  }

  Future<void> _fetchFilterData() async {
    _isLoading.value = true;
    final result = await propertyServices.getFilterData();
    result.fold((l) => null, (r) {
      filterData.value = r;
      print(r.toPrint());
    });
    _isLoading.value = false;
  }

  final RxInt selectedPropertyFilterIndex = 0.obs;

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  void changePropertyFilter(int index) {
    selectedPropertyFilterIndex.value = index;
    // TODO: Connect with HomeController filtering
  }
}
