class HomepageData {
  final List<Property> featuredProperties;

  HomepageData({required this.featuredProperties});

  factory HomepageData.fromJson(Map<String, dynamic> json) {
    return HomepageData(
      featuredProperties: (json['featured_properties'] as List<dynamic>)
          .map((e) => Property.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'featured_properties': featuredProperties.map((e) => e.toJson()).toList(),
    };
  }
}

class Property {
  final int id;
  final String title;
  final String? description;
  final String propertyCategory;
  final String propertyType;
  final String propertyMode;
  final String? listingCategory;
  final String? city;
  final int isFeatured;
  final String? state;
  final String? locality;
  final int? basePrice;
  final String? furnishingStatus;
  final String? possessionDate;
  final String? ageOfProperty;
  final int? yearBuilt;
  final int? parkingCoveredCount;
  final int? parkingOpenCount;
  final int? plotAreaSqft;
  final int? buildingAreaSqft;
  final String? formattedPrice;
  final PriceRange? priceRange;
  final String? bhkList;
  final String? bathroomList;
  final String? areaRange;
  final String? image;
  final int imagesCount;
  final List<Amenity> amenities;
  final Media media;
  final bool isFavorited;
  final ShareData shareData;

  Property({
    required this.id,
    required this.title,
    this.description,
    required this.propertyCategory,
    required this.propertyType,
    required this.propertyMode,
    this.listingCategory,
    this.city,
    required this.isFeatured,
    this.state,
    this.locality,
    this.basePrice,
    this.furnishingStatus,
    this.possessionDate,
    this.ageOfProperty,
    this.yearBuilt,
    this.parkingCoveredCount,
    this.parkingOpenCount,
    this.plotAreaSqft,
    this.buildingAreaSqft,
    this.formattedPrice,
    this.priceRange,
    this.bhkList,
    this.bathroomList,
    this.areaRange,
    this.image,
    required this.imagesCount,
    required this.amenities,
    required this.media,
    required this.isFavorited,
    required this.shareData,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      propertyCategory: json['property_category'] as String,
      propertyType: json['property_type'] as String,
      propertyMode: json['property_mode'] as String,
      listingCategory: json['listing_category'] as String?,
      city: json['city'] as String?,
      isFeatured: json['is_featured'] as int,
      state: json['state'] as String?,
      locality: json['locality'] as String?,
      basePrice: json['base_price'] as int?,
      furnishingStatus: json['furnishing_status'] as String?,
      possessionDate: json['possession_date'] as String?,
      ageOfProperty: json['age_of_property'] as String?,
      yearBuilt: json['year_built'] as int?,
      parkingCoveredCount: json['parking_covered_count'] as int?,
      parkingOpenCount: json['parking_open_count'] as int?,
      plotAreaSqft: json['plot_area_sqft'] as int?,
      buildingAreaSqft: json['building_area_sqft'] as int?,
      formattedPrice: json['formatted_price'] as String?,
      priceRange: json['price_range'] != null
          ? PriceRange.fromJson(json['price_range'] as Map<String, dynamic>)
          : null,
      bhkList: json['bhk_list'] as String?,
      bathroomList: json['bathroom_list'] as String?,
      areaRange: json['area_range'] as String?,
      image: json['image'] as String?,
      imagesCount: json['images_count'] as int,
      amenities: (json['amenities'] as List<dynamic>)
          .map((e) => Amenity.fromJson(e as Map<String, dynamic>))
          .toList(),
      media: Media.fromJson(json['media'] as Map<String, dynamic>),
      isFavorited: json['is_favorited'] as bool,
      shareData: ShareData.fromJson(json['share_data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'property_category': propertyCategory,
      'property_type': propertyType,
      'property_mode': propertyMode,
      'listing_category': listingCategory,
      'city': city,
      'is_featured': isFeatured,
      'state': state,
      'locality': locality,
      'base_price': basePrice,
      'furnishing_status': furnishingStatus,
      'possession_date': possessionDate,
      'age_of_property': ageOfProperty,
      'year_built': yearBuilt,
      'parking_covered_count': parkingCoveredCount,
      'parking_open_count': parkingOpenCount,
      'plot_area_sqft': plotAreaSqft,
      'building_area_sqft': buildingAreaSqft,
      'formatted_price': formattedPrice,
      'price_range': priceRange?.toJson(),
      'bhk_list': bhkList,
      'bathroom_list': bathroomList,
      'area_range': areaRange,
      'image': image,
      'images_count': imagesCount,
      'amenities': amenities.map((e) => e.toJson()).toList(),
      'media': media.toJson(),
      'is_favorited': isFavorited,
      'share_data': shareData.toJson(),
    };
  }
}

class PriceRange {
  final String min;
  final String max;

  PriceRange({required this.min, required this.max});

  factory PriceRange.fromJson(Map<String, dynamic> json) {
    return PriceRange(min: json['min'] as String, max: json['max'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'min': min, 'max': max};
  }
}

class Amenity {
  final int id;
  final String name;

  Amenity({required this.id, required this.name});

  factory Amenity.fromJson(Map<String, dynamic> json) {
    return Amenity(id: json['id'] as int, name: json['name'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class Media {
  final List<MediaItem> images;
  final List<MediaItem> videos;
  final List<MediaItem> documents;

  Media({required this.images, required this.videos, required this.documents});

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      images: (json['images'] as List<dynamic>)
          .map((e) => MediaItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      videos: (json['videos'] as List<dynamic>)
          .map((e) => MediaItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      documents: (json['documents'] as List<dynamic>)
          .map((e) => MediaItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'images': images.map((e) => e.toJson()).toList(),
      'videos': videos.map((e) => e.toJson()).toList(),
      'documents': documents.map((e) => e.toJson()).toList(),
    };
  }
}

class MediaItem {
  final int id;
  final String url;
  final String fileType;
  final String? documentType;
  final String mediaLevel;

  MediaItem({
    required this.id,
    required this.url,
    required this.fileType,
    this.documentType,
    required this.mediaLevel,
  });

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      id: json['id'] as int,
      url: json['url'] as String,
      fileType: json['file_type'] as String,
      documentType: json['document_type'] as String?,
      mediaLevel: json['media_level'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'file_type': fileType,
      'document_type': documentType,
      'media_level': mediaLevel,
    };
  }
}

class ShareData {
  final String title;
  final String message;
  final String image;
  final String url;

  ShareData({
    required this.title,
    required this.message,
    required this.image,
    required this.url,
  });

  factory ShareData.fromJson(Map<String, dynamic> json) {
    return ShareData(
      title: json['title'] as String,
      message: json['message'] as String,
      image: json['image'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'message': message, 'image': image, 'url': url};
  }
}
