import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/services/property_services.dart';
import 'package:real_estate_app/features/favorite/models/favorite_property.dart';
import 'package:real_estate_app/features/property/models/property_model.dart';

class FavoriteController extends GetxController {
  final Logger log = Logger();
  final PropertyServices propertyServices = Get.find<PropertyServices>();

  final RxList<FavoriteProperty> _savedProperties = RxList<FavoriteProperty>();
  List<FavoriteProperty> get savedProperties => _savedProperties;

  final RxBool isFavorite = false.obs;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  void _init() async {
    await _fetchSavedProperties();
  }

  Future<void> refreshSavedProperties() async {
    await _fetchSavedProperties();
  }

  void fetchSavedProperties() async {
    await _fetchSavedProperties();
  }

  void saveFavorite(Property property) {
    final exist = _savedProperties.any((element) => element.id == property.id);
    if (exist) {
      _savedProperties.removeAt(
        _savedProperties.indexWhere((element) => element.id == property.id),
      );
    }

    _savedProperties.add(FavoriteProperty.fromProperty(property));
    refresh();
    log.d("Property added to favorites");
  }

  Future<void> _fetchSavedProperties() async {
    _isLoading.value = true;
    final result = await propertyServices.getSavedProperties();
    result.fold(
      (failure) {
        _isLoading.value = false;
        log.e("Failed to fetch saved properties: ${failure.message}");
      },
      (res) {
        log.d("Saved properties: ${res.data.property.length}");
        // _savedData.value = res;
        _savedProperties.value = res.data.property;
        _isLoading.value = false;
      },
    );
  }

  void toggleFavorite({required String type, required int propertyId}) {
    _toggleFavorite(type: type, propertyId: propertyId);
  }

  Future<void> _toggleFavorite({
    required String type,
    required int propertyId,
  }) async {
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
    // _fetchSavedProperties();
  }
}
