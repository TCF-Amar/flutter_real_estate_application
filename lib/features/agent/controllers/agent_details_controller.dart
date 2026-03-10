import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';
import 'package:real_estate_app/core/services/agent_services.dart';
import 'package:real_estate_app/features/agent/models/agent_details_response_model.dart';
import 'package:real_estate_app/features/favorite/controllers/favorite_controller.dart';
import 'package:real_estate_app/features/favorite/models/favorite_property.dart';
import 'package:real_estate_app/features/property/models/property_model.dart';
import 'package:real_estate_app/features/property/models/review_request_model.dart';
import 'package:real_estate_app/features/shared/models/pagination_model.dart';
import 'package:real_estate_app/features/shared/models/review_model.dart';
import 'package:real_estate_app/features/shared/models/reviews_summary_model.dart';
import 'package:real_estate_app/features/shared/widgets/app_snackbar.dart';

// ─────────────────────────────────────────────
// Model
// ─────────────────────────────────────────────

class EnquiryRequestModel {
  final String name;
  final String phone;
  final String email;
  final String message;

  EnquiryRequestModel({
    required this.name,
    required this.phone,
    required this.email,
    required this.message,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'phone': phone,
    'email': email,
    'message': message,
  };
}

// ─────────────────────────────────────────────
// Controller
// ─────────────────────────────────────────────

class AgentDetailsController extends GetxController {
  // ── Dependencies ──────────────────────────

  final Logger log = Logger();
  late final AgentServices agentServices;

  // ── Lifecycle ─────────────────────────────

  @override
  void onInit() {
    super.onInit();
    agentServices = Get.find<AgentServices>();
    final id = Get.arguments != null ? Get.arguments['id'] as int? : null;
    if (id != null) {
      _fetchAgentById(id);
      fetchReviews(id);
    } else {
      log.e('No agent id provided in arguments');
    }
  }

  // ── Agent Details ─────────────────────────

  RxBool isLoading = false.obs;

  final Rx<AgentDetailModel?> _agentDetails = Rxn<AgentDetailModel>();
  AgentDetailModel? get agentDetails => _agentDetails.value;

  void _fetchAgentById(int id) async {
    final result = await agentServices.getAgentDetails(id);
    result.fold(
      (l) => log.e("Error fetching agent details: ${l.message}"),
      (r) => _agentDetails.value = r,
    );
  }

  // ── Property Filtering ────────────────────

  final RxList<Property> filterPropertiesList = <Property>[].obs;

  List<Property> _filteredProperties = [];
  int _visibleCount = 0;
  final int _step = 3;

  final RxBool _isLastPage = false.obs;
  bool get isLastPage => _isLastPage.value;

  void filterProperties(String filter) {
    if (agentDetails == null) return;

    final properties = agentDetails!.properties;

    switch (filter) {
      case 'For Sale':
        _filteredProperties = properties
            .where((p) => p.listingCategory == 'for_sale')
            .toList();
        break;
      case 'For Rent':
        _filteredProperties = properties
            .where((p) => p.listingCategory == 'for_rent')
            .toList();
        break;
      default:
        _filteredProperties = properties;
    }

    _visibleCount = _step.clamp(0, _filteredProperties.length);
    filterPropertiesList.assignAll(_filteredProperties.take(_visibleCount));
    _isLastPage.value = _visibleCount >= _filteredProperties.length;
  }

  void loadMoreProperties() {
    if (_isLastPage.value) return;

    _visibleCount = (_visibleCount + _step).clamp(
      0,
      _filteredProperties.length,
    );
    filterPropertiesList.assignAll(_filteredProperties.take(_visibleCount));
    _isLastPage.value = _visibleCount >= _filteredProperties.length;
  }

  void updatePropertyFavorite(int id) {
    final idx = filterPropertiesList.indexWhere((item) => item.id == id);
    if (idx != -1) {
      filterPropertiesList[idx] = filterPropertiesList[idx].copyWith(
        isFavorited: !filterPropertiesList[idx].isFavorited,
      );
      filterPropertiesList.refresh();
    }

    final p = FavoriteProperty.fromProperty(filterPropertiesList[idx]);
    Get.find<FavoriteController>().toggleFavoriteProperty(p);
  }

  // ── Reviews ───────────────────────────────

  final RxList<ReviewModel> _reviews = RxList<ReviewModel>();
  List<ReviewModel> get reviews => _reviews;

  final Rxn<ReviewSummaryModel> _reviewsSummary = Rxn<ReviewSummaryModel>();
  ReviewSummaryModel? get reviewsSummary => _reviewsSummary.value;

  final Rxn<PaginationModel> _pagination = Rxn<PaginationModel>();
  PaginationModel? get pagination => _pagination.value;

  final RxBool _isLoadingReviews = false.obs;
  bool get isLoadingReviews => _isLoadingReviews.value;

  final RxBool _isLoadingMoreReviews = false.obs;
  bool get isLoadingMoreReviews => _isLoadingMoreReviews.value;

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

    final result = await agentServices.getReviews(
      agentDetails!.id,
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

    final result = await agentServices.getReviews(id, page: page);
    result.fold((l) => log.e("Error fetching reviews: ${l.message}"), (r) {
      _reviews.value = r.data.reviews;
      _pagination.value = r.data.pagination;
      _reviewsSummary.value = r.data.reviewsSummary;
      log.d("Fetched reviews: ${r.data.reviews.length}");
    });

    _isLoadingReviews.value = false;
  }

  // ── Review Submission ─────────────────────

  final TextEditingController commentController = TextEditingController();

  final RxInt _rating = 0.obs;
  int get rating => _rating.value;

  void setRating(int rating) => _rating.value = rating;

  Future<void> addReview(int id) async {
    _isLoadingReviews.value = true;
    log.d(
      "Adding review for agent $id — rating: $rating, comment: ${commentController.text}",
    );

    final result = await agentServices.addReview(
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

  // ── Enquiry ───────────────────────────────

  final RxBool _isSendingEnquiry = false.obs;
  bool get isSendingEnquiry => _isSendingEnquiry.value;

  Future<bool> sendEnquiry({
    required String name,
    required String phone,
    required String email,
    required String message,
  }) async {
    return true;
  }
}
