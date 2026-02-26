class SavedProperty {
  final int? id;
  final String? title;
  final String? propertyCategory;
  final String? propertyType;
  final String? listingCategory;
  final String? city;
  final String? state;
  final num? basePrice;
  final String? formattedPrice;
  final PriceRange? priceRange;
  final String? bhkRange;
  final String? areaRange;
  final String? image;
  final int? imagesCount;
  final String? projectName;
  final List<dynamic> amenities;
  final bool? isFavorited;
  final String? ownerImage;

  SavedProperty({
    this.id,
    this.title,
    this.propertyCategory,
    this.propertyType,
    this.listingCategory,
    this.city,
    this.state,
    this.basePrice,
    this.formattedPrice,
    this.priceRange,
    this.bhkRange,
    this.areaRange,
    this.image,
    this.imagesCount,
    this.projectName,
    this.amenities = const [],
    this.isFavorited,
    this.ownerImage,
  });

  factory SavedProperty.fromJson(Map<String, dynamic> json) {
    return SavedProperty(
      id: json['id'] as int?,
      title: json['title'] as String?,
      propertyCategory: json['property_category'] as String?,
      propertyType: json['property_type'] as String?,
      listingCategory: json['listing_category'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      basePrice: json['base_price'] as num?,
      formattedPrice: json['formatted_price'] as String?,
      priceRange: json['price_range'] != null
          ? PriceRange.fromJson(json['price_range'] as Map<String, dynamic>)
          : null,
      bhkRange: json['bhk_range'] as String?,
      areaRange: json['area_range'] as String?,
      image: json['image'] as String?,
      imagesCount: json['images_count'] as int?,
      projectName: json['project_name'] as String?,
      amenities: json['amenities'] as List<dynamic>? ?? [],
      isFavorited: json['is_favorited'] as bool?,
      ownerImage: json['owner_image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'property_category': propertyCategory,
      'property_type': propertyType,
      'listing_category': listingCategory,
      'city': city,
      'state': state,
      'base_price': basePrice,
      'formatted_price': formattedPrice,
      'price_range': priceRange?.toJson(),
      'bhk_range': bhkRange,
      'area_range': areaRange,
      'image': image,
      'images_count': imagesCount,
      'project_name': projectName,
      'amenities': amenities,
      'is_favorited': isFavorited,
      'owner_image': ownerImage,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is SavedProperty && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class PriceRange {
  final String? min;
  final String? max;

  PriceRange({this.min, this.max});

  factory PriceRange.fromJson(Map<String, dynamic> json) {
    return PriceRange(min: json['min'] as String?, max: json['max'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {'min': min, 'max': max};
  }

  @override
  String toString() => 'PriceRange(min: $min, max: $max)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriceRange && min == other.min && max == other.max;

  @override
  int get hashCode => min.hashCode ^ max.hashCode;
}
