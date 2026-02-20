import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/services/property_services.dart';
import 'package:real_estate_app/features/explore/models/property_filter_model.dart';

class ExploreController extends GetxController {
  final PropertyServices propertyServices = Get.find<PropertyServices>();
  final RxInt selectedTabIndex = 0.obs;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = "".obs;

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

    // Trigger search when query changes (debounced)
    debounce(
      searchQuery,
      (_) => _performSearch(),
      time: const Duration(milliseconds: 500),
    );

    // Trigger search when tab changes
    ever(selectedTabIndex, (_) => _performSearch());
  }

  void _performSearch() {
    switch (selectedTabIndex.value) {
      case 0:
        projectSearch();
        break;
      case 1:
        agentSearch();
        break;
      case 2:
        developerSearch();
        break;
    }
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
    projectSearch();
  }

  void projectSearch() {}
  void agentSearch() {}
  void developerSearch() {}
}
