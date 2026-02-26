import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/services/explore_services.dart';
import 'package:real_estate_app/features/property/models/property_detail_model.dart';
import 'package:real_estate_app/features/saved/controllers/favorite_controller.dart';
import 'package:real_estate_app/features/shared/models/pagination_model.dart';
import 'package:real_estate_app/features/shared/models/review_model.dart';

class PropertyDetailsController extends GetxController {
  final ExploreServices propertyServices = Get.find<ExploreServices>();
  final FavoriteController favoriteController = Get.find<FavoriteController>();
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
      fetchReviews(id);
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
}
