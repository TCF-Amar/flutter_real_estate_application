import 'package:get/get.dart';
import 'package:real_estate_app/core/errors/failure.dart';
import 'package:real_estate_app/features/favorite/models/favorite_property.dart';
import 'package:real_estate_app/features/property/controllers/property_controller.dart';
import 'package:real_estate_app/features/property/models/property_model.dart';
import 'package:real_estate_app/core/services/home_services.dart';
import 'package:real_estate_app/features/favorite/controllers/favorite_controller.dart';

class HomeController extends GetxController {
  final HomeServices _homeServices = Get.find<HomeServices>();

  RxBool isLoading = false.obs;
  RxList<Property> featuredProperties = <Property>[].obs;
  RxList<Property> allProperties = <Property>[].obs;
  RxList<Property> recommendedProperties = <Property>[].obs;
  final FavoriteController favoritesController = Get.find<FavoriteController>();
  final Rxn<Failure> _error = Rxn<Failure>();
  Failure? get error => _error.value;

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
        _error.value = failure;
      },
      (response) {
        featuredProperties.assignAll(response.data.featuredProperties);
        allProperties.assignAll(response.data.featuredProperties);
        // Use a distinct copy for recommended so filtering doesn't corrupt the source list
        recommendedProperties.assignAll(
          List<Property>.from(response.data.featuredProperties),
        );
      },
    );
    isLoading.value = false;
  }

  void refreshData() async {
    isLoading.value = true;
    final result = await _homeServices.getHomepageData();
    result.fold(
      (failure) {
        // Handle failure (e.g., show snackbar)
        _error.value = failure;
      },
      (response) {
        featuredProperties.assignAll(response.data.featuredProperties);
        allProperties.assignAll(response.data.featuredProperties);
        // Use a distinct copy for recommended so filtering doesn't corrupt the source list
        recommendedProperties.assignAll(
          List<Property>.from(response.data.featuredProperties),
        );
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
    final allIndex = allProperties.indexWhere(
      (property) => property.id == propertyId,
    );
    if (allIndex == -1) return;

    final updatedProperty = allProperties[allIndex].copyWith(
      isFavorited: !(allProperties[allIndex].isFavorited),
    );
    allProperties[allIndex] = updatedProperty;
    allProperties.refresh();

    final featuredIndex = featuredProperties.indexWhere(
      (property) => property.id == propertyId,
    );
    if (featuredIndex != -1) {
      featuredProperties[featuredIndex] = updatedProperty;
      featuredProperties.refresh();
    }

    final recommendedIndex = recommendedProperties.indexWhere(
      (property) => property.id == propertyId,
    );
    if (recommendedIndex != -1) {
      recommendedProperties[recommendedIndex] = updatedProperty;
      recommendedProperties.refresh();
    }
  }

  void toggleFavoriteProperty({required int propertyId}) {
    updateFavorite(propertyId);
    Get.find<PropertyController>().updateFavoriteData(propertyId);
    final p = FavoriteProperty.fromProperty(
      allProperties.firstWhere((p) => p.id == propertyId),
    );
    favoritesController.toggleFavoriteProperty(p);
  }
}
