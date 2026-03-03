import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/services/property_services.dart';
import 'package:real_estate_app/features/agent/controllers/agent_controller.dart';
import 'package:real_estate_app/features/agent/models/agent_model.dart';
import 'package:real_estate_app/features/home/controllers/home_controller.dart';
import 'package:real_estate_app/features/property/controllers/property_controller.dart';
import 'package:real_estate_app/features/property/models/property_detail_model.dart';
import 'package:real_estate_app/features/property/models/property_model.dart';
import 'package:real_estate_app/features/property/models/review_request_model.dart';
import 'package:real_estate_app/features/favorite/controllers/favorite_controller.dart';
import 'package:real_estate_app/features/shared/models/pagination_model.dart';
import 'package:real_estate_app/features/shared/models/review_model.dart';
import 'package:real_estate_app/features/shared/widgets/app_snackbar.dart';

class PropertyDetailsController extends GetxController {
  late final PropertyServices propertyServices;
  late final FavoriteController favoriteController;
  late final AgentController agentController;
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
    propertyServices = Get.find<PropertyServices>();
    favoriteController = Get.find<FavoriteController>();
    agentController = Get.find<AgentController>();
    final id = Get.arguments['id'];
    if (id != null) {
      propertyId.value = id;
      fetchPropertyDetails(id);
      fetchReviews(id);
      fetchSimilarProperties(id);
    }
    ever(propertyId, (id) {
      fetchPropertyDetails(id);
      fetchReviews(id);
      fetchSimilarProperties(id);
    });
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

  void toggleFavorite() {
    if (propertyDetail == null) return;

    final currentStatus = propertyDetail!.isFavorited ?? false;
    Get.find<PropertyController>().updateFavoriteData(propertyId.value);
    Get.find<HomeController>().updateFavorite(propertyId.value);
    final updated = propertyDetail!.copyWith(isFavorited: !currentStatus);
    _propertyDetail.value = updated;
    favoriteController.toggleFavorite(
      type: "property",
      propertyId: propertyId.value,
    );
    favoriteController.fetchSavedProperties();
  }

  void updateCurrentIndex(int index) {
    _currentIndex.value = index;
  }

  void next() {
    if (currentIndex < propertyDetail!.media!.images.length - 1) {
      _currentIndex.value++;
    } else {
      _currentIndex.value = 0;
    }
  }

  void previous() {
    if (currentIndex > 0) {
      _currentIndex.value--;
    } else {
      _currentIndex.value = propertyDetail!.media!.images.length - 1;
    }
  }

  final RxBool _isLoadingAgent = false.obs;
  bool get isLoadingAgent => _isLoadingAgent.value;

  Future<AgentModel?> fetchAgentById(int id) async {
    // Fast path: already cached
    if (agentController.agentCache.containsKey(id)) {
      log.d('Agent $id served from cache');
      return agentController.agentCache[id];
    }

    // Slow path: fetch from API
    _isLoadingAgent.value = true;
    AgentModel? agent;
    try {
      final result = await agentController.services.getAgentDetails(id);
      result.fold((l) => log.e('fetchAgentById($id) error: ${l.message}'), (r) {
        agent = AgentModel.fromAgentDetailModel(r);
        agentController.agentCache[id] = agent!;
        log.d('Fetched agent $id: ${r.name}');
      });
    } finally {
      _isLoadingAgent.value = false;
    }
    return agent; 
  }
  // ─── Reviews ─────────────────────────────────────────────────────────────

  final RxList<ReviewModel> _reviews = RxList<ReviewModel>();
  List<ReviewModel> get reviews => _reviews;

  final RxBool _isLoadingReviews = false.obs;
  bool get isLoadingReviews => _isLoadingReviews.value;

  final RxBool _isLoadingMoreReviews = false.obs;
  bool get isLoadingMoreReviews => _isLoadingMoreReviews.value;

  final Rxn<PaginationModel> _pagination = Rxn<PaginationModel>();
  PaginationModel? get pagination => _pagination.value;

  int _currentPage = 1;
  bool get hasMore =>
      _pagination.value != null &&
      _pagination.value!.currentPage < _pagination.value!.lastPage;

  void fetchReviews(int id) async {
    _currentPage = 1;
    _reviews.clear();
    await _fetchReviews(id, page: _currentPage);
  }

  Future<void> loadMoreReviews() async {
    if (!hasMore || _isLoadingMoreReviews.value) return;
    _currentPage++;
    _isLoadingMoreReviews.value = true;
    final result = await propertyServices.getReviews(
      propertyId.value,
      page: _currentPage,
    );
    result.fold(
      (l) {
        log.e("Error loading more reviews: ${l.message}");
        _currentPage--; // roll back on failure
      },
      (r) {
        _reviews.addAll(r.data.reviews);
        _pagination.value = r.data.pagination;
        log.d(
          "Loaded more reviews — page $_currentPage, total ${_reviews.length}",
        );
      },
    );
    _isLoadingMoreReviews.value = false;
  }

  Future<void> _fetchReviews(int id, {int page = 1}) async {
    _isLoadingReviews.value = true;
    final result = await propertyServices.getReviews(id, page: page);
    result.fold((l) => log.e("Error fetching reviews: ${l.message}"), (r) {
      log.d("Fetched reviews: ${r.data.reviews.length}");
      _reviews.value = r.data.reviews;
      _pagination.value = r.data.pagination;
    });
    _isLoadingReviews.value = false;
  }

  TextEditingController commentController = TextEditingController();
  final RxInt _rating = 0.obs;
  int get rating => _rating.value;

  void setRating(int rating) {
    _rating.value = rating;
  }

  Future<void> addReview(int id) async {
    _isLoadingReviews.value = true;
    log.d("Adding review for property $id");
    log.d("Rating: $rating");
    log.d("Comment: ${commentController.text}");
    final result = await propertyServices.addReview(
      id,
      ReviewRequestModel(rating: rating, comment: commentController.text),
    );
    result.fold(
      (l) {
        log.e("Error adding review: ${l.message}");
        AppSnackbar.info(l.message);
      },
      (r) {
        log.d("Review added successfully");
      },
    );
    fetchReviews(id);
    commentController.clear();
    _rating.value = 0;
    _isLoadingReviews.value = false;
  }

  // ─── Similar Properties ──────────────────────────────────────────────────

  final RxList<Property> _similarProperties = RxList<Property>();
  List<Property> get similarProperties => _similarProperties;

  final RxBool _isLoadingSimilar = false.obs;
  bool get isLoadingSimilar => _isLoadingSimilar.value;

  Future<void> fetchSimilarProperties(int id) async {
    _isLoadingSimilar.value = true;
    final result = await propertyServices.getSimilarProperties(id);
    result.fold(
      (l) => log.e("Error fetching similar properties: ${l.message}"),
      (r) {
        log.d("Fetched similar properties: ${r.data.length}");
        _similarProperties.value = r.data;
      },
    );
    _isLoadingSimilar.value = false;
  }

  @override
  void onClose() {
    // Called automatically by GetX when the propertyDetails route is popped.
    commentController.dispose();
    super.onClose();
  }
}
