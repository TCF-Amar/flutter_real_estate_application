class PropertySearchParams {
  final String? city;
  final String? propertyCategory;
  final List<int>? bhk;
  final int? minPrice;
  final int? maxPrice;
  final int? minArea;
  final int? maxArea;
  final String? amenities;
  final String? listingCategory;
  final String? keywords;
  final String? propertyStatus;
  final String? propertyType;
  final int? perPage;
  final int? page;

  PropertySearchParams({
    this.city,
    this.propertyCategory,
    this.bhk,
    this.minPrice,
    this.maxPrice,
    this.minArea,
    this.maxArea,
    this.amenities,
    this.listingCategory,
    this.keywords,
    this.propertyStatus,
    this.propertyType,
    this.perPage = 10,
    this.page = 1,
  });

  PropertySearchParams copyWith({
    String? city,
    String? propertyCategory,
    List<int>? bhk,
    int? minPrice,
    int? maxPrice,
    int? minArea,
    int? maxArea,
    String? amenities,
    String? listingCategory,
    String? keywords,
    String? propertyStatus,
    String? propertyType,
    int? perPage,
    int? page,
    bool clearCity = false,
    bool clearPropertyCategory = false,
    bool clearBhk = false,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
    bool clearMinArea = false,
    bool clearMaxArea = false,
    bool clearAmenities = false,
    bool clearListingCategory = false,
    bool clearKeywords = false,
    bool clearPropertyStatus = false,
    bool clearPropertyType = false,
  }) {
    return PropertySearchParams(
      city: clearCity ? null : (city ?? this.city),
      propertyCategory: clearPropertyCategory
          ? null
          : (propertyCategory ?? this.propertyCategory),
      bhk: clearBhk ? null : (bhk ?? this.bhk),
      minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
      minArea: clearMinArea ? null : (minArea ?? this.minArea),
      maxArea: clearMaxArea ? null : (maxArea ?? this.maxArea),
      amenities: clearAmenities ? null : (amenities ?? this.amenities),
      listingCategory: clearListingCategory
          ? null
          : (listingCategory ?? this.listingCategory),
      keywords: clearKeywords ? null : (keywords ?? this.keywords),
      propertyStatus: clearPropertyStatus
          ? null
          : (propertyStatus ?? this.propertyStatus),
      propertyType: clearPropertyType
          ? null
          : (propertyType ?? this.propertyType),
      perPage: perPage ?? this.perPage,
      page: page ?? this.page,
    );
  }

  /// Converts the model to a map suitable for query parameters.
  /// Only non-null, non-empty values are included.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (city != null && city!.isNotEmpty) map['city'] = city;
    if (propertyCategory != null && propertyCategory!.isNotEmpty) {
      map['property_category'] = propertyCategory;
    }
    if (bhk != null && bhk!.isNotEmpty) {
      map['bhk'] = bhk!.join(',');
    }
    if (minPrice != null && minPrice! > 0) map['min_price'] = minPrice;
    if (maxPrice != null && maxPrice! < 100000000) map['max_price'] = maxPrice;
    if (minArea != null && minArea! > 0) map['min_area'] = minArea;
    if (maxArea != null && maxArea! < 10000) map['max_area'] = maxArea;
    if (amenities != null && amenities!.isNotEmpty) {
      map['amenities[]'] = amenities; // note the [] if required by API
    }
    if (listingCategory != null && listingCategory!.isNotEmpty) {
      map['listing_category'] = listingCategory;
    }
    if (keywords != null && keywords!.isNotEmpty) map['search'] = keywords;
    if (propertyStatus != null && propertyStatus!.isNotEmpty) {
      map['property_status'] = propertyStatus;
    }
    if (propertyType != null && propertyType!.isNotEmpty) {
      map['property_type'] = propertyType;
    }
    if (perPage != null) map['per_page'] = perPage;
    if (page != null) map['page'] = page;

    return map;
  }

  /// Converts the model to a URL query string starting with '?'.
  String toQueryString() {
    final params = toJson();
    if (params.isEmpty) return '';

    final queryParts = <String>[];
    params.forEach((key, value) {
      if (value is List) {
        for (var item in value) {
          queryParts.add('$key=${Uri.encodeComponent(item.toString())}');
        }
      } else {
        queryParts.add('$key=${Uri.encodeComponent(value.toString())}');
      }
    });

    return '?${queryParts.join('&')}';
  }
}
