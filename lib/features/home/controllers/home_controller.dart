import 'package:get/get.dart';
import 'package:real_estate_app/features/property/controllers/property_controller.dart';
import 'package:real_estate_app/features/property/models/property_model.dart';
import 'package:real_estate_app/core/services/home_services.dart';
import 'package:real_estate_app/features/saved/controllers/favorite_controller.dart';

class HomeController extends GetxController {
  final HomeServices _homeServices = Get.find<HomeServices>();

  RxBool isLoading = false.obs;
  RxList<Property> featuredProperties = <Property>[].obs;
  RxList<Property> allProperties = <Property>[].obs;
  RxList<Property> recommendedProperties = <Property>[].obs;
  final FavoriteController favoritesController = Get.find<FavoriteController>();

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

    if (filter == 'Nearby' && recommendedProperties.isEmpty) {
      recommendedProperties.assignAll(allProperties);
    }
  }

  void updateFavorite(int propertyId) {
    final index = allProperties.indexWhere(
      (property) => property.id == propertyId,
    );
    if (index == -1) return;
    final property = allProperties[index];
    final updatedProperty = property.copyWith(
      isFavorited: !(property.isFavorited),
    );
    allProperties[index] = updatedProperty;
    featuredProperties[index] = updatedProperty;
    recommendedProperties[index] = updatedProperty;
    allProperties.refresh();
    featuredProperties.refresh();
    recommendedProperties.refresh();
  }

  void toggleFavorite({required int propertyId}) {
    updateFavorite(propertyId);
    Get.find<PropertyController>().updateFavoriteData(propertyId);
    favoritesController.toggleFavorite(
      type: "property",
      propertyId: propertyId,
    );
  }
}
