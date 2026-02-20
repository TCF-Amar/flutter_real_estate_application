import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/services/property_services.dart';
import 'package:real_estate_app/features/explore/models/property_filter_model.dart';
import 'package:real_estate_app/features/explore/models/property_model.dart';

class ExploreController extends GetxController {
  final Logger log = Logger();
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

  final RxList<Property> _properties = RxList<Property>([]);
  final RxList<Property> _filteredProperties = RxList<Property>([]);
  final RxBool _isEmpty = false.obs;

  List<Property> get properties => _properties;
  List<Property> get filteredProperties => _filteredProperties;
  bool get isEmpty => _isEmpty.value;

  final RxInt currentPage = 1.obs;
  final RxInt totalItems = 0.obs;
  final RxInt lastPage = 1.obs;
  final RxInt perPage = 5.obs;

  final ScrollController scrollController = ScrollController();
  final RxBool _isMoreLoading = false.obs;
  bool get isMoreLoading => _isMoreLoading.value;

  @override
  void onInit() {
    super.onInit();
    fetchFilterData();
    projectSearch();

    // Trigger search when query changes (debounced)
    debounce(searchQuery, (_) {
      propertyServices.page.value = 1;
      _performSearch();
    }, time: const Duration(milliseconds: 500));

    // Trigger search when tab changes
    ever(selectedTabIndex, (_) {
      propertyServices.page.value = 1;
      _performSearch();
    });

    // Add scroll listener for pagination
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !isLoading &&
          !isMoreLoading &&
          currentPage.value < lastPage.value) {
        fetchMoreProperties();
      }
    });
  }

  void _performSearch() {
    propertyServices.keywords.value = searchQuery.value;
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
    });
    _isLoading.value = false;
  }

  final RxInt selectedPropertyFilterIndex = 0.obs;

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  void changePropertyFilter(int index) {
    selectedPropertyFilterIndex.value = index;
    final status = propertyFilters[index];
    propertyServices.propertyStatus.value = status == "All" ? "" : status;
    propertyServices.page.value = 1;
    String str = "All";
    if (str == "All") {
      _filteredProperties.value = properties;
    } else if (str == "Ready to move") {
      _filteredProperties.value = properties
          .where((p) => p.propertyType == "Ready to move")
          .toList();
    } else if (str == "Under Construction") {
      _filteredProperties.value = properties
          .where((p) => p.propertyType == "Under Construction")
          .toList();
    }

    // projectSearch();
  }

  void projectSearch() async {
    await _fetchProperties();
  }

  void agentSearch() {}
  void developerSearch() {}

  // Filter State
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 100000000.0.obs;
  final RxInt minArea = 0.obs;
  final RxInt maxArea = 10000.obs;
  final RxList<int> selectedBhk = <int>[].obs;
  final RxString selectedAmenities = RxString('');
  final RxString selectedListingCategories = RxString('');
  final RxnString selectedStatus = RxnString();
  final RxnString selectedSort = RxnString();

  void initializeFilters() {
    minPrice.value = propertyServices.minPrice.value.toDouble();
    maxPrice.value = propertyServices.maxPrice.value.toDouble();
    minArea.value = (propertyServices.minArea.value ?? 0).toInt();
    maxArea.value = (propertyServices.maxArea.value ?? 10000).toInt();
    selectedBhk.assignAll(propertyServices.bhk);
    selectedAmenities.value = propertyServices.amenities.value;

    // Find the label for the listing category from the slug
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

  void applyFilters() {
    final data = filterData.value?.data;

    propertyServices.minPrice.value = minPrice.value.toInt();
    propertyServices.maxPrice.value = maxPrice.value.toInt();
    propertyServices.minArea.value = minArea.value.toInt();
    propertyServices.maxArea.value = maxArea.value.toInt();
    propertyServices.bhk.assignAll(selectedBhk);
    propertyServices.amenities.value = selectedAmenities.value;

    // Map label back to slug
    if (data != null && selectedListingCategories.value.isNotEmpty) {
      propertyServices.listingCategory.value =
          data.listingCategories?[selectedListingCategories.value] ?? '';
    } else {
      propertyServices.listingCategory.value = '';
    }

    propertyServices.page.value = 1;
    _performSearch();
    Get.back();
  }

  void resetFilters() {
    minPrice.value = 0;
    maxPrice.value = 100000000;
    minArea.value = 0;
    maxArea.value = 10000;
    selectedBhk.clear();
    selectedAmenities.value = '';
    selectedListingCategories.value = '';
    selectedStatus.value = null;
    selectedSort.value = null;

    propertyServices.keywords.value = '';
    propertyServices.propertyStatus.value = '';
    searchQuery.value = '';
    searchController.clear();
    propertyServices.page.value = 1;
    _performSearch();
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

  void fetchMoreProperties() async {
    if (currentPage.value < lastPage.value && !isMoreLoading) {
      propertyServices.page.value = currentPage.value + 1;
      await _fetchProperties();
    }
  }

  void refreshProperties() async {
    resetFilters();
    await _fetchProperties();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
