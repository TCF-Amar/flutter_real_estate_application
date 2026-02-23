import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/services/property_services.dart';
import 'package:real_estate_app/features/saved_properties/models/saved_property.dart';

class SavedPropertiesController extends GetxController {
  final Logger log = Logger();
  final PropertyServices propertyServices = Get.find<PropertyServices>();

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

  Future<void> toggleFavorite({
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
  }

  // Future<void> fetchSavedProperties() async {
  //   final result = await propertyServices.getSavedProperties();
  //   result.fold(
  //     (failure) {
  //       return;
  //     },
  //     (savedResponse) {
  //       // _savedProperties.value = savedResponse;
  //       _savedProperties.assignAll(savedResponse);
  //       log.d("asdasd${_savedProperties.length}");
  //     },
  //   );
  //   _isLoading.value = false;
  // }

  void saveProperty(SavedProperty property) {
    _savedProperties.add(property);
  }
}
