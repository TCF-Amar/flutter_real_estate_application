import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/services/property_services.dart';
import 'package:real_estate_app/features/explore/models/property_detail.dart';
import 'package:real_estate_app/features/saved_properties/controllers/saved_properties_controller.dart';

class PropertyDetailsController extends GetxController {
  final PropertyServices propertyServices = Get.find<PropertyServices>();
  final SavedPropertiesController savedPropertiesController =
      Get.find<SavedPropertiesController>();
  final Logger log = Logger();

  final Rxn<PropertyDetail> _propertyDetail = Rxn<PropertyDetail>();
  PropertyDetail? get propertyDetail => _propertyDetail.value;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxInt propertyId = 0.obs;

  final RxInt _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  @override
  void onInit() {
    super.onInit();
    final id = Get.arguments['id'];
    if (id != null) {
      propertyId.value = id;
      fetchPropertyDetails(id);
    }
  }

  Future<void> fetchPropertyDetails(int id) async {
    _isLoading.value = true;
    final result = await propertyServices.getPropertyDetails(id);
    result.fold((l) => log.e("Error fetching property details: ${l.message}"), (
      r,
    ) {
      log.d("Fetched property details: ${r.data?.media?.images.length}");
      _propertyDetail.value = r.data;
    });
    _isLoading.value = false;
  }

  Future<void> toggleFavorite() async {
    if (propertyDetail == null) return;

    final currentStatus = propertyDetail!.isFavorited ?? false;
    final updated = propertyDetail!.copyWith(isFavorited: !currentStatus);
    _propertyDetail.value = updated;

    await savedPropertiesController.toggleFavorite(
      type: "property",
      propertyId: propertyId.value,
    );
  }

  void updateCurrentIndex(int index) {
    _currentIndex.value = index;
  }
}
