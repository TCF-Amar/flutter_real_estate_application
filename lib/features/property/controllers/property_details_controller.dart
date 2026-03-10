import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/services/property_services.dart';
import 'package:real_estate_app/features/agent/controllers/agent_controller.dart';
import 'package:real_estate_app/features/agent/models/agent_model.dart';
import 'package:real_estate_app/features/favorite/controllers/favorite_controller.dart';
import 'package:real_estate_app/features/favorite/models/favorite_property.dart';
import 'package:real_estate_app/features/home/controllers/home_controller.dart';
import 'package:real_estate_app/features/property/controllers/property_controller.dart';
import 'package:real_estate_app/features/property/models/property_detail_model.dart';
import 'package:real_estate_app/features/property/models/property_model.dart';
import 'package:real_estate_app/features/property/models/review_request_model.dart';
import 'package:real_estate_app/features/shared/models/pagination_model.dart';
import 'package:real_estate_app/features/shared/models/review_model.dart';
import 'package:real_estate_app/features/shared/models/reviews_summary_model.dart';
import 'package:real_estate_app/features/shared/widgets/app_snackbar.dart';

class PropertyDetailsController extends GetxController {
  // ─── Dependencies ────────────────────────────────────────────────────────────

  final log = Logger();
  late final PropertyServices _propertyServices;
  late final FavoriteController _favoriteController;
  late final AgentController _agentController;

  // ─── Property Detail ─────────────────────────────────────────────────────────

  final _propertyDetail = Rxn<PropertyDetail>();
  final _isLoading = false.obs;
  final propertyId = 0.obs;

  PropertyDetail? get propertyDetail => _propertyDetail.value;
  bool get isLoading => _isLoading.value;

  // ─── Lifecycle ───────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _propertyServices = Get.find<PropertyServices>();
    _favoriteController = Get.find<FavoriteController>();
    _agentController = Get.find<AgentController>();

    final id = Get.arguments['id'];
    if (id != null) {
      propertyId.value = id;
      _loadAll(id);
    }

    ever(propertyId, _loadAll);
  }

  void _loadAll(int id) {
    fetchPropertyDetails(id);
    fetchReviews(id);
    fetchSimilarProperties(id);
  }

  Future<void> fetchPropertyDetails(int id) async {
    _isLoading.value = true;
    final result = await _propertyServices.getPropertyDetails(id);
    result.fold((l) => log.e('Error fetching property details: ${l.message}'), (
      r,
    ) {
      log.d(
        'Fetched property details — images: ${r.data?.media?.images.length}',
      );
      _propertyDetail.value = r.data;
    });
    _isLoading.value = false;
  }

  // ─── Image Carousel ──────────────────────────────────────────────────────────

  final _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  void updateCurrentIndex(int index) => _currentIndex.value = index;

  void next() {
    final length = propertyDetail?.media?.images.length ?? 0;
    _currentIndex.value = (currentIndex < length - 1) ? currentIndex + 1 : 0;
  }

  void previous() {
    final length = propertyDetail?.media?.images.length ?? 0;
    _currentIndex.value = (currentIndex > 0) ? currentIndex - 1 : length - 1;
  }

  // ─── Reviews ─────────────────────────────────────────────────────────────────

  final _reviews = RxList<ReviewModel>();
  final _reviewsSummary = Rxn<ReviewSummaryModel>();
  final _pagination = Rxn<PaginationModel>();
  final _isLoadingReviews = false.obs;
  final _isLoadingMoreReviews = false.obs;
  final commentController = TextEditingController();
  final _rating = 0.obs;

  int _currentPage = 1;

  List<ReviewModel> get reviews => _reviews;
  ReviewSummaryModel? get reviewsSummary => _reviewsSummary.value;
  PaginationModel? get pagination => _pagination.value;
  bool get isLoadingReviews => _isLoadingReviews.value;
  bool get isLoadingMoreReviews => _isLoadingMoreReviews.value;
  int get rating => _rating.value;
  bool get hasMore =>
      _pagination.value != null &&
      _pagination.value!.currentPage < _pagination.value!.lastPage;

  void setRating(int value) => _rating.value = value;

  void fetchReviews(int id) async {
    _currentPage = 1;
    _reviews.clear();
    await _fetchReviews(id, page: _currentPage);
  }

  Future<void> loadMoreReviews() async {
    if (!hasMore || _isLoadingMoreReviews.value) return;
    _currentPage++;
    _isLoadingMoreReviews.value = true;
    final result = await _propertyServices.getReviews(
      propertyId.value,
      page: _currentPage,
    );
    result.fold(
      (l) {
        log.e('Error loading more reviews: ${l.message}');
        _currentPage--; // roll back on failure
      },
      (r) {
        _reviews.addAll(r.data.reviews);
        _pagination.value = r.data.pagination;
        _reviewsSummary.value = r.data.reviewsSummary;
        log.d(
          'Loaded more reviews — page $_currentPage, total ${_reviews.length}',
        );
      },
    );
    _isLoadingMoreReviews.value = false;
  }

  Future<void> addReview(int id) async {
    _isLoadingReviews.value = true;
    log.d('Adding review — property: $id, rating: $rating');
    final result = await _propertyServices.addReview(
      id,
      ReviewRequestModel(rating: rating, comment: commentController.text),
    );
    result.fold((l) {
      log.e('Error adding review: ${l.message}');
      AppSnackbar.info(l.message);
    }, (r) => log.d('Review added successfully'));
    fetchReviews(id);
    commentController.clear();
    _rating.value = 0;
    _isLoadingReviews.value = false;
  }

  Future<void> _fetchReviews(int id, {int page = 1}) async {
    _isLoadingReviews.value = true;
    final result = await _propertyServices.getReviews(id, page: page);
    result.fold((l) => log.e('Error fetching reviews: ${l.message}'), (r) {
      log.d('Fetched reviews: ${r.data.reviews.length}');
      _reviews.value = r.data.reviews;
      _pagination.value = r.data.pagination;
      _reviewsSummary.value = r.data.reviewsSummary;
    });
    _isLoadingReviews.value = false;
  }

  // ─── Similar Properties ──────────────────────────────────────────────────────

  final _similarProperties = RxList<Property>();
  final _isLoadingSimilar = false.obs;

  List<Property> get similarProperties => _similarProperties;
  bool get isLoadingSimilar => _isLoadingSimilar.value;

  Future<void> fetchSimilarProperties(int id) async {
    _isLoadingSimilar.value = true;
    final result = await _propertyServices.getSimilarProperties(id);
    result.fold(
      (l) => log.e('Error fetching similar properties: ${l.message}'),
      (r) {
        log.d('Fetched similar properties: ${r.data.length}');
        _similarProperties.value = r.data;
      },
    );
    _isLoadingSimilar.value = false;
  }

  // ─── Agent ───────────────────────────────────────────────────────────────────

  final _isLoadingAgent = false.obs;
  bool get isLoadingAgent => _isLoadingAgent.value;

  Future<AgentModel?> fetchAgentById(int id) async {
    if (_agentController.agentCache.containsKey(id)) {
      log.d('Agent $id served from cache');
      return _agentController.agentCache[id];
    }
    _isLoadingAgent.value = true;
    AgentModel? agent;
    try {
      final result = await _agentController.services.getAgentDetails(id);
      result.fold((l) => log.e('fetchAgentById($id) error: ${l.message}'), (r) {
        agent = AgentModel.fromAgentDetailModel(r);
        _agentController.agentCache[id] = agent!;
        log.d('Fetched agent $id: ${r.name}');
      });
    } finally {
      _isLoadingAgent.value = false;
    }
    return agent;
  }

  // ─── Favorites ───────────────────────────────────────────────────────────────

  void updateDetailsFavorite() {
    if (propertyDetail == null) return;
    Get.find<PropertyController>().updateFavoriteData(propertyId.value);
    Get.find<HomeController>().updateFavorite(propertyId.value);
    _propertyDetail.value = propertyDetail!.copyWith(
      isFavorited: !(propertyDetail!.isFavorited ?? false),
    );
    final p = FavoriteProperty.fromPropertyDetails(propertyDetail!);
    _favoriteController.toggleFavoriteProperty(p);
  }

  /// Optimistic toggle on a similar property card.
  void updateSimilarFavorite(int id) async {
    Get.find<PropertyController>().updateFavoriteData(id);
    Get.find<HomeController>().updateFavorite(id);
    final idx = _similarProperties.indexWhere((p) => p.id == id);
    if (idx != -1) {
      _similarProperties[idx] = _similarProperties[idx].copyWith(
        isFavorited: !_similarProperties[idx].isFavorited,
      );
      _similarProperties.refresh();
    }
    final p = FavoriteProperty.fromProperty(_similarProperties[idx]);
    _favoriteController.toggleFavoriteProperty(p);
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}
