import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/core/services/property_services.dart';
import 'package:real_estate_app/features/property/models/property_model.dart';
import 'package:real_estate_app/features/search/models/search_model.dart';
import 'package:real_estate_app/features/shared/models/property_search_params.dart';

class AppSearchController extends GetxController {
  final log = Logger();
  final PropertyServices ps = Get.find();
  final _query = "".obs;
  String get query => _query.value;

  final searchController = TextEditingController();
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxBool _hasNextPage = true.obs;
  bool get hasNextPage => _hasNextPage.value;

  final searchParams = PropertySearchParams(perPage: 10, page: 1).obs;
  final RxList<RecentSearchModel> recentSearchesRx = recentSearches.obs;

  final RxnString _selectedListingCategory = RxnString();
  String? get selectedListingCategory => _selectedListingCategory.value;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      _query.value = searchController.text;
      searchParams.value = searchParams.value.copyWith(
        // keywords: searchController.text,
        propertyCategory: searchController.text,
        page: 1,
      );
    });

    // debounce(_query, (_) => search(), time: const Duration(milliseconds: 500));
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void setQuery(String q) {
    searchController.text = q;
  }

  void search() async {
    await _search();
  }

  void updateListingCategory(String? category) {
    _selectedListingCategory.value = category;
    _hasNextPage.value = true;
    searchParams.value = searchParams.value.copyWith(
      listingCategory: category,
      clearListingCategory: category == null,
      page: 1,
    );
    _search();
  }

  void searchMore() async {
    if (isLoading || !hasNextPage) return;
    searchParams.value = searchParams.value.copyWith(
      page: searchParams.value.page! + 1,
    );
    await _search(searchMore: true);
  }

  void toggleFavorite(Property property) async {
    final index = _properties.indexWhere((p) => p.id == property.id);
    if (index == -1) return;

    // Optimistic UI update
    final updatedProperty = property.copyWith(
      isFavorited: !property.isFavorited,
    );
    _properties[index] = updatedProperty;

    final res = await ps.toggleFavoriteProperty(
      type: "property",
      propertyId: property.id,
    );

    res.fold(
      (l) {
        log.e("Failed to toggle favorite: ${l.message}");
        // Revert on failure
        _properties[index] = property;
      },
      (r) {
        log.i("Favorite toggled for property: ${property.id}");
      },
    );
  }

  final RxList<Property> _properties = RxList<Property>();
  List<Property> get properties => _properties;

  Future<void> _search({bool searchMore = false}) async {
    _isLoading.value = true;
    try {
      final p = searchParams.value;
      final res = await ps.searchProperties(params: p);
      res.fold(
        (l) {
          log.e(l.message);
        },
        (r) {
          if (r.data.isNotEmpty) {
            // Save as recent search
            final firstProperty = r.data.first;
            final newRecent = RecentSearchModel(
              query: query,
              image: firstProperty.image ?? firstProperty.shareData.image,
              title: firstProperty.title,
              location:
                  "${firstProperty.locality ?? ''}, ${firstProperty.city ?? ''}",
            );

            // Remove existing search with same query to avoid duplicates
            recentSearchesRx.removeWhere((element) => element.query == query);
            // Insert at the beginning
            recentSearchesRx.insert(0, newRecent);

            // Limit to 5 items
            if (recentSearchesRx.length > 5) {
              recentSearchesRx.removeLast();
            }

            if (Get.currentRoute != AppRoutes.searchResult) {}
          }
          if (searchMore) {
            _properties.addAll(r.data);
          } else {
            _properties.assignAll(r.data);
          }

          // Update hasNextPage
          _hasNextPage.value =
              r.data.length >= (searchParams.value.perPage ?? 10);
        },
      );
    } finally {
      Get.toNamed(AppRoutes.searchResult);
      _isLoading.value = false;
    }
  }
}
