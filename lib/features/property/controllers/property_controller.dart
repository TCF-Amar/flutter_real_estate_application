import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/errors/failure.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/services/property_services.dart';
import 'package:real_estate_app/features/favorite/controllers/favorite_controller.dart';
import 'package:real_estate_app/features/favorite/models/favorite_property.dart';
import 'package:real_estate_app/features/home/controllers/home_controller.dart';
import 'package:real_estate_app/features/property/models/property_filter.model.dart';
import 'package:real_estate_app/features/property/models/property_model.dart';

class PropertyController extends GetxController {
  // ─── Dependencies ────────────────────────────────────────────────────────────

  final log = Logger();
  final _propertyServices = Get.find<PropertyServices>();
  final _favoritesController = Get.find<FavoriteController>();
  final _homeController = Get.find<HomeController>();

  // Keep public getter for views that reference propertyServices directly
  PropertyServices get propertyServices => _propertyServices;

  // ─── Loading State ───────────────────────────────────────────────────────────

  final _isLoading = false.obs;
  final _isFilterLoading = false.obs;
  final _isMoreLoading = false.obs;

  bool get isLoading => _isLoading.value;
  bool get isFilterLoading => _isFilterLoading.value;
  bool get isMoreLoading => _isMoreLoading.value;

  final Rxn<Failure> _error = Rxn<Failure>();
  Failure? get error => _error.value;

  // ─── Property Data ───────────────────────────────────────────────────────────

  final _properties = RxList<Property>([]);
  final _filteredProperties = RxList<Property>([]);
  final _isEmpty = false.obs;
  final filterData = Rx<PropertyFilterModel?>(null);

  List<Property> get properties => _properties;
  List<Property> get filteredProperties => _filteredProperties;
  bool get isEmpty => _isEmpty.value;

  // ─── Pagination ──────────────────────────────────────────────────────────────

  final currentPage = 1.obs;
  final totalItems = 0.obs;
  final lastPage = 1.obs;
  final perPage = 5.obs;
  final scrollController = ScrollController();

  // ─── Search & Navigation ─────────────────────────────────────────────────────

  final selectedTabIndex = 0.obs;
  final selectedIndex = 0.obs;
  final searchController = TextEditingController();
  final searchQuery = ''.obs;

  // ─── Filters ─────────────────────────────────────────────────────────────────

  final selectedPropertyFilterIndex = 0.obs;
  final minPrice = 0.0.obs;
  final maxPrice = 100000000.0.obs;
  final minArea = 0.obs;
  final maxArea = 10000.obs;
  final selectedBhk = <int>[].obs;
  final selectedAmenities = RxString('');
  final selectedListingCategories = RxString('');
  final selectedStatus = RxnString();
  final selectedSort = RxnString();
  final selectedPropertyType = RxnString();

  final List<String> propertyFilters = [
    'All',
    'Ready to move',
    'Under Construction',
  ];

  // ─── Lifecycle ───────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    fetchFilterData();
    _fetchProperties();

    debounce(
      searchQuery,
      (_) => handleSearch(),
      time: const Duration(milliseconds: 500),
    );

    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    scrollController
      ..removeListener(_onScroll)
      ..dispose();
    searchController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !isLoading &&
        !isMoreLoading &&
        currentPage.value < lastPage.value) {
      _loadMoreProperties();
    }
  }

  // ─── Search ──────────────────────────────────────────────────────────────────

  void handleSearch() {
    _propertyServices.keywords.value = searchQuery.value;
    _propertyServices.page.value = 1;
    _fetchProperties();
  }

  // ─── Filters ─────────────────────────────────────────────────────────────────

  void initializeFilters() {
    minPrice.value = _propertyServices.minPrice.value.toDouble();
    maxPrice.value = _propertyServices.maxPrice.value.toDouble();
    minArea.value = (_propertyServices.minArea.value ?? 0).toInt();
    maxArea.value = (_propertyServices.maxArea.value ?? 10000).toInt();
    selectedBhk.assignAll(_propertyServices.bhk);
    selectedAmenities.value = _propertyServices.amenities.value;

    final currentSlug = _propertyServices.listingCategory.value;
    final categories = filterData.value?.data.listingCategories;
    if (categories != null && currentSlug.isNotEmpty) {
      selectedListingCategories.value = categories.entries
          .firstWhere(
            (e) => e.value == currentSlug,
            orElse: () => categories.entries.first,
          )
          .key;
    } else {
      selectedListingCategories.value = '';
    }
  }

  void applySort(String? label) {
    selectedSort.value = label;
    _propertyServices.page.value = 1;
    _fetchProperties();
  }

  Future<void> changePropertyFilter(int index) async {
    selectedIndex.value = index;
    await resetFilters(shouldFetch: false);

    String type = '';
    if (index == 1) type = 'ready_to_move';
    if (index == 2) type = 'under_construction';

    _propertyServices.propertyType.value = type;
    _fetchProperties();
  }

  void applyFilters({bool shouldFetch = true}) {
    final data = filterData.value?.data;

    _propertyServices.minPrice.value = minPrice.value.toInt();
    _propertyServices.maxPrice.value = maxPrice.value.toInt();
    _propertyServices.minArea.value = minArea.value.toInt();
    _propertyServices.maxArea.value = maxArea.value.toInt();
    _propertyServices.bhk.assignAll(selectedBhk);
    _propertyServices.amenities.value = selectedAmenities.value;

    if (data != null && selectedListingCategories.value.isNotEmpty) {
      _propertyServices.listingCategory.value =
          data.listingCategories?[selectedListingCategories.value] ?? '';
    } else {
      _propertyServices.listingCategory.value = '';
    }

    _propertyServices.page.value = 1;
    if (shouldFetch) _fetchProperties();

    Get.back();
  }

  Future<void> resetFilters({bool shouldFetch = true}) async {
    log.d('Resetting all filters');

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

    _propertyServices
      ..keywords.value = ''
      ..propertyStatus.value = ''
      ..propertyType.value = ''
      ..listingCategory.value = ''
      ..amenities.value = ''
      ..minPrice.value = 0
      ..maxPrice.value = 100000000
      ..minArea.value = null
      ..maxArea.value = null
      ..bhk.clear()
      ..city.value = ''
      ..page.value = 1;

    searchQuery.value = '';
    searchController.clear();

    if (shouldFetch) _fetchProperties();
  }

  // ─── Fetching ────────────────────────────────────────────────────────────────

  void fetchFilterData() async => await _fetchFilterData();

  Future<void> _fetchFilterData() async {
    _isFilterLoading.value = true;
    final result = await _propertyServices.getFilterData();
    result.fold(
      (l) {
        _error.value = l;
        return null;
      },
      (r) {
        _error.value = null;
        filterData.value = r;
      },
    );
    _isFilterLoading.value = false;
  }

  Future<void> _fetchProperties() async {
    if (_propertyServices.page.value == 1) {
      _isLoading.value = true;
    } else {
      _isMoreLoading.value = true;
    }

    final result = await _propertyServices.searchProperties();
    result.fold(
      (l) {
        _error.value = l;
        log.e('Error fetching properties: ${l.message}');
      },
      (r) {
        _error.value = null;
        log.d(
          'Fetched ${r.data.length} properties — page ${_propertyServices.page.value}',
        );
        if (_propertyServices.page.value == 1) {
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
      },
    );

    _applySortToList();
    _isLoading.value = false;
    _isMoreLoading.value = false;
  }

  void _applySortToList() {
    final label = selectedSort.value;
    if (label == null) return;

    switch (label) {
      case 'Newest First':
        _properties.sort((a, b) => b.id.compareTo(a.id));
        _filteredProperties.sort((a, b) => b.id.compareTo(a.id));
        break;
      case 'Price: Low to High':
        _filteredProperties.assignAll(
          [..._filteredProperties]
            ..sort((a, b) => (a.basePrice ?? 0).compareTo(b.basePrice ?? 0)),
        );
        break;
      case 'Price: High to Low':
        _filteredProperties.assignAll(
          [..._filteredProperties]
            ..sort((a, b) => (b.basePrice ?? 0).compareTo(a.basePrice ?? 0)),
        );
        break;
    }
  }

  // ─── Pagination & Refresh ────────────────────────────────────────────────────

  void _loadMoreProperties() {
    if (currentPage.value < lastPage.value && !isMoreLoading) {
      _propertyServices.page.value = currentPage.value + 1;
      _fetchProperties();
    }
  }

  Future<void> fetchMoreProperties() async {
    if (currentPage.value < lastPage.value && !isMoreLoading) {
      _propertyServices.page.value = currentPage.value + 1;
      await _fetchProperties();
    }
  }

  Future<void> refreshProperties() async {
    selectedIndex.value = 0;
    await resetFilters();
  }

  // ─── Favorites ───────────────────────────────────────────────────────────────

  void updateFavoriteData(int propertyId) {
    final pIdx = _properties.indexWhere((p) => p.id == propertyId);
    if (pIdx != -1) {
      _properties[pIdx] = _properties[pIdx].copyWith(
        isFavorited: !_properties[pIdx].isFavorited,
      );
      _properties.refresh();
    }

    final fIdx = _filteredProperties.indexWhere((p) => p.id == propertyId);
    if (fIdx != -1) {
      _filteredProperties[fIdx] = _filteredProperties[fIdx].copyWith(
        isFavorited: !_filteredProperties[fIdx].isFavorited,
      );

      _filteredProperties.refresh();
    }
  }

  void toggleFavoriteProperty({required int propertyId}) {
    updateFavoriteData(propertyId);
    final property = _filteredProperties.firstWhere((p) => p.id == propertyId);
    final p = FavoriteProperty.fromProperty(property);
    _favoritesController.toggleFavoriteProperty(p);
    _homeController.updateFavorite(propertyId);
  }
}
