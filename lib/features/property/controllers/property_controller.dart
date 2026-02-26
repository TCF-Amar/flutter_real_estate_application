import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/services/explore_services.dart';
import 'package:real_estate_app/features/home/controllers/home_controller.dart';
import 'package:real_estate_app/features/property/models/property_filter.model.dart';
import 'package:real_estate_app/features/property/models/property_model.dart';
import 'package:real_estate_app/features/saved/controllers/favorite_controller.dart';

class PropertyController extends GetxController {
  final Logger log = Logger();

  final ExploreServices propertyServices = Get.find<ExploreServices>();
  final FavoriteController favoritesController = Get.find<FavoriteController>();
  final HomeController homeController = Get.find<HomeController>();

  //* Navigation & Search State
  final RxInt selectedTabIndex = 0.obs;
  final RxInt selectedIndex = 0.obs;
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  //* Loading State
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxBool _isFilterLoading = false.obs;
  bool get isFilterLoading => _isFilterLoading.value;

  //* Property Data State
  final RxList<Property> _properties = RxList<Property>([]);
  final RxList<Property> _filteredProperties = RxList<Property>([]);
  final RxBool _isEmpty = false.obs;
  List<Property> get properties => _properties;
  List<Property> get filteredProperties => _filteredProperties;
  bool get isEmpty => _isEmpty.value;

  final Rx<PropertyFilterModel?> filterData = Rx<PropertyFilterModel?>(null);

  //* Pagination State
  final RxInt currentPage = 1.obs;
  final RxInt totalItems = 0.obs;
  final RxInt lastPage = 1.obs;
  final RxInt perPage = 5.obs;
  final ScrollController scrollController = ScrollController();
  final RxBool _isMoreLoading = false.obs;
  bool get isMoreLoading => _isMoreLoading.value;

  //* Filter Sheet Logic (Advanced Filters)
  final RxInt selectedPropertyFilterIndex = 0.obs;
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 100000000.0.obs;
  final RxInt minArea = 0.obs;
  final RxInt maxArea = 10000.obs;
  final RxList<int> selectedBhk = <int>[].obs;
  final RxString selectedAmenities = RxString('');
  final RxString selectedListingCategories = RxString('');
  final RxnString selectedStatus = RxnString();
  final RxnString selectedSort = RxnString();
  final RxnString selectedPropertyType = RxnString();

  final List<String> propertyFilters = [
    "All",
    "Ready to move",
    "Under Construction",
  ];

  //* Lifecycle
  @override
  void onInit() {
    super.onInit();
    fetchFilterData();
    _fetchProperties();

    debounce(searchQuery, (_) {
      handleSearch();
    }, time: const Duration(milliseconds: 500));

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !isLoading &&
          !isMoreLoading &&
          currentPage.value < lastPage.value) {
        _loadMoreProperties();
      }
    });
  }

  void handleSearch() {
    propertyServices.keywords.value = searchQuery.value;
    propertyServices.page.value = 1;
    _fetchProperties();
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }

  void initializeFilters() {
    minPrice.value = propertyServices.minPrice.value.toDouble();
    maxPrice.value = propertyServices.maxPrice.value.toDouble();
    minArea.value = (propertyServices.minArea.value ?? 0).toInt();
    maxArea.value = (propertyServices.maxArea.value ?? 10000).toInt();
    selectedBhk.assignAll(propertyServices.bhk);
    selectedAmenities.value = propertyServices.amenities.value;

    final currentSlug = propertyServices.listingCategory.value;
    final categories = filterData.value?.data.listingCategories;
    if (categories != null && currentSlug.isNotEmpty) {
      final label = categories.entries
          .firstWhere(
            (e) => e.value == currentSlug,
            orElse: () => categories.entries.first,
          )
          .key;
      selectedListingCategories.value = label;
    } else {
      selectedListingCategories.value = '';
    }
  }

  Future<void> changePropertyFilter(int index) async {
    selectedIndex.value = index;
    await resetFilters(shouldFetch: false);

    String type = '';
    if (index == 1) type = 'ready_to_move';
    if (index == 2) type = 'under_construction';

    propertyServices.propertyType.value = type;
    _fetchProperties();
  }

  void applyFilters() {
    final data = filterData.value?.data;

    propertyServices.minPrice.value = minPrice.value.toInt();
    propertyServices.maxPrice.value = maxPrice.value.toInt();
    propertyServices.minArea.value = minArea.value.toInt();
    propertyServices.maxArea.value = maxArea.value.toInt();
    propertyServices.bhk.assignAll(selectedBhk);
    propertyServices.amenities.value = selectedAmenities.value;

    if (data != null && selectedListingCategories.value.isNotEmpty) {
      propertyServices.listingCategory.value =
          data.listingCategories?[selectedListingCategories.value] ?? '';
    } else {
      propertyServices.listingCategory.value = '';
    }

    propertyServices.page.value = 1;
    _fetchProperties();
    Get.back();
  }

  //
  Future<void> resetFilters({bool shouldFetch = true}) async {
    log.d("Resetting all filters");
    minPrice.value = 0;
    maxPrice.value = 100000000;
    minArea.value = 0;
    maxArea.value = 10000;
    selectedBhk.clear();
    selectedAmenities.value = '';
    selectedListingCategories.value = '';
    selectedStatus.value = null;
    selectedSort.value = null;
    selectedPropertyType.value = null;

    propertyServices.keywords.value = '';
    propertyServices.propertyStatus.value = '';
    propertyServices.propertyType.value = '';
    propertyServices.listingCategory.value = '';
    propertyServices.amenities.value = '';
    propertyServices.minPrice.value = 0;
    propertyServices.maxPrice.value = 100000000;
    propertyServices.minArea.value = null;
    propertyServices.maxArea.value = null;
    propertyServices.bhk.clear();
    propertyServices.city.value = '';

    searchQuery.value = '';
    searchController.clear();
    propertyServices.page.value = 1;

    if (shouldFetch) {
      _fetchProperties();
    }
  }

  void fetchFilterData() async {
    await _fetchFilterData();
  }

  Future<void> _fetchFilterData() async {
    _isFilterLoading.value = true;
    final result = await propertyServices.getFilterData();
    result.fold((l) => null, (r) {
      filterData.value = r;
    });
    _isFilterLoading.value = false;
  }

  Future<void> _fetchProperties() async {
    if (propertyServices.page.value == 1) {
      _isLoading.value = true;
    } else {
      _isMoreLoading.value = true;
    }

    final result = await propertyServices.searchProperties();
    result.fold((l) => log.e("Error fetching properties: ${l.message}"), (r) {
      log.d(
        "Fetched ${r.data.length} properties for page ${propertyServices.page.value}",
      );
      if (propertyServices.page.value == 1) {
        _properties.assignAll(r.data);
        _filteredProperties.assignAll(r.data);
      } else {
        _properties.addAll(r.data);
        _filteredProperties.addAll(r.data);
      }
      _isEmpty.value = _properties.isEmpty;
      currentPage.value = r.pagination?.currentPage ?? 1;
      totalItems.value = r.pagination?.total ?? _properties.length;
      lastPage.value = r.pagination?.lastPage ?? 1;
      perPage.value = r.pagination?.perPage ?? 5;
    });

    _isLoading.value = false;
    _isMoreLoading.value = false;
  }

  //* Pagination & Refresh
  void _loadMoreProperties() {
    if (currentPage.value < lastPage.value && !isMoreLoading) {
      propertyServices.page.value = currentPage.value + 1;
      _fetchProperties();
    }
  }

  Future<void> fetchMoreProperties() async {
    if (currentPage.value < lastPage.value && !isMoreLoading) {
      propertyServices.page.value = currentPage.value + 1;
      await _fetchProperties();
    }
  }

  Future<void> refreshProperties() async {
    selectedIndex.value = 0;
    await resetFilters();
  }

  //* Favorites
  void updateFavoriteData(int propertyId) {
    final index = _properties.indexWhere((p) => p.id == propertyId);
    if (index == -1) return;
    final property = _properties[index];
    final update = property.copyWith(isFavorited: !property.isFavorited);

    _properties[index] = update;
    _filteredProperties[index] = update;
    _filteredProperties.refresh();
    _properties.refresh();
  }

  void toggleFavorite({required int propertyId}) {
    updateFavoriteData(propertyId);
    homeController.updateFavorite(propertyId);
    favoritesController.toggleFavorite(
      propertyId: propertyId,
      type: 'property',
    );
  }
}
