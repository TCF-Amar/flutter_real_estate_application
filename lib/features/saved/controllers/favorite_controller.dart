import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/services/explore_services.dart';
import 'package:real_estate_app/features/saved/models/saved_property.dart';

class FavoriteController extends GetxController {
  final Logger log = Logger();
  final ExploreServices propertyServices = Get.find<ExploreServices>();

  final RxList<SavedProperty> _savedProperties = RxList<SavedProperty>([]);
  List<SavedProperty> get savedProperties => _savedProperties;

  final RxBool isFavorite = false.obs;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // @override
  // void onInit() {
  //   super.onInit();
  //   _init();
  // }

  // void _init() async {
  //   await fetchSavedProperties();
  // }

  void toggleFavorite({required String type, required int propertyId}) {
    _toggleFavorite(type: type, propertyId: propertyId);
  }

  Future<void> _toggleFavorite({
    required String type,
    required int propertyId,
  }) async {
    // homeController.toggleFavorite(propertyId: propertyId);
    // exploreController.toggleFavorite(propertyId: propertyId);
    final result = await propertyServices.toggleFavorite(
      type: type,
      propertyId: propertyId,
    );
    result.fold(
      (failure) {
        return propertyId;
      },
      (res) {
        if (res.isFavorite) {
          log.d("Property added to favorites");
        } else {
          log.d("Property removed from favorites");
        }
      },
    );
  }

  void saveProperty(SavedProperty property) {
    _savedProperties.add(property);
  }
}
