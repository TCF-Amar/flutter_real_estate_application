import 'package:get/get.dart';
import 'package:real_estate_app/features/home/models/home_data_model.dart';
import 'package:real_estate_app/core/services/home_services.dart';

class HomeController extends GetxController {
  final HomeServices _homeServices = Get.find<HomeServices>();

  RxBool isLoading = false.obs;
  RxList<Property> featuredProperties = <Property>[].obs;
  RxList<Property> allProperties = <Property>[].obs;
  RxList<Property> recommendedProperties = <Property>[].obs;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  void _init() async {
    await getHomepageData();
  }

  Future<void> getHomepageData() async {
    isLoading.value = true;
    final result = await _homeServices.getHomepageData();
    result.fold(
      (failure) {
        // Handle failure (e.g., show snackbar)
      },
      (response) {
        featuredProperties.assignAll(response.data.featuredProperties);
        allProperties.assignAll(response.data.featuredProperties);
        recommendedProperties.assignAll(response.data.featuredProperties);
      },
    );
    isLoading.value = false;
  }

  void filterProperties(String filter) {
    if (filter == 'All') {
      recommendedProperties.assignAll(allProperties);
      return;
    }

    recommendedProperties.assignAll(
      allProperties.where((property) {
        final category =
            property.listingCategory?.replaceAll('_', ' ').toLowerCase() ?? '';
        return category == filter.toLowerCase();
      }).toList(),
    );

    // If "Nearby" doesn't have a specific category, we might want to show all or use a different logic.
    // For now, mirroring the user's intent of filtering by category if it's not 'All'.
    if (filter == 'Nearby' && recommendedProperties.isEmpty) {
      recommendedProperties.assignAll(allProperties);
    }
  }
}
