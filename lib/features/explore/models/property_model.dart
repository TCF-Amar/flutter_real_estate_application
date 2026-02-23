import 'package:real_estate_app/core/constants/environments.dart';
import 'package:real_estate_app/core/utils/safe_parser.dart';

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
      id: toInt(json['id']) ?? 0,
      title: toStr(json['title']) ?? '',
      description: toStr(json['description']),
      propertyCategory: toStr(json['property_category']) ?? '',
      propertyType: toStr(json['property_type']) ?? '',
      propertyMode: toStr(json['property_mode']) ?? '',
      listingCategory: toStr(json['listing_category']),
      city: toStr(json['city']),
      isFeatured: toInt(json['is_featured']) ?? 0,
      state: toStr(json['state']),
      locality: toStr(json['locality']),
      basePrice: toInt(json['base_price']),
      furnishingStatus: toStr(json['furnishing_status']),
      possessionDate: toStr(json['possession_date']),
      ageOfProperty: toStr(json['age_of_property']),
      yearBuilt: toInt(json['year_built']),
      parkingCoveredCount: toInt(json['parking_covered_count']),
      parkingOpenCount: toInt(json['parking_open_count']),
      plotAreaSqft: toInt(json['plot_area_sqft']),
      buildingAreaSqft: toInt(json['building_area_sqft']),
      formattedPrice: toStr(json['formatted_price']),
      priceRange: json['price_range'] != null
          ? PriceRange.fromJson(json['price_range'] as Map<String, dynamic>)
          : null,
      bhkList: toStr(json['bhk_list']),
      bathroomList: toStr(json['bathroom_list']),
      areaRange: toStr(json['area_range']),
      image: toStr(json['image']),
      imagesCount: toInt(json['images_count']) ?? 0,
      amenities:
          (json['amenities'] as List<dynamic>?)
              ?.map((e) => Amenity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      media: json['media'] != null
          ? Media.fromJson(json['media'] as Map<String, dynamic>)
          : Media(images: [], videos: [], documents: []),
      isFavorited:
          json['is_favorited'] == true ||
          json['is_favorited'] == 1 ||
          json['is_favorited']?.toString() == "true",
      shareData: json['share_data'] != null
          ? ShareData.fromJson(json['share_data'] as Map<String, dynamic>)
          : ShareData(title: '', message: '', image: '', url: ''),
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

  Property copyWith({
    int? id,
    String? title,
    String? description,
    String? propertyCategory,
    String? propertyType,
    String? propertyMode,
    String? listingCategory,
    String? city,
    int? isFeatured,
    String? state,
    String? locality,
    int? basePrice,
    String? furnishingStatus,
    String? possessionDate,
    String? ageOfProperty,
    int? yearBuilt,
    int? parkingCoveredCount,
    int? parkingOpenCount,
    int? plotAreaSqft,
    int? buildingAreaSqft,
    String? formattedPrice,
    PriceRange? priceRange,
    String? bhkList,
    String? bathroomList,
    String? areaRange,
    String? image,
    int? imagesCount,
    List<Amenity>? amenities,
    Media? media,
    bool? isFavorited,
    ShareData? shareData,
  }) {
    return Property(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      propertyCategory: propertyCategory ?? this.propertyCategory,
      propertyType: propertyType ?? this.propertyType,
      propertyMode: propertyMode ?? this.propertyMode,
      listingCategory: listingCategory ?? this.listingCategory,
      city: city ?? this.city,
      isFeatured: isFeatured ?? this.isFeatured,
      state: state ?? this.state,
      locality: locality ?? this.locality,
      basePrice: basePrice ?? this.basePrice,
      furnishingStatus: furnishingStatus ?? this.furnishingStatus,
      possessionDate: possessionDate ?? this.possessionDate,
      ageOfProperty: ageOfProperty ?? this.ageOfProperty,
      yearBuilt: yearBuilt ?? this.yearBuilt,
      parkingCoveredCount: parkingCoveredCount ?? this.parkingCoveredCount,
      parkingOpenCount: parkingOpenCount ?? this.parkingOpenCount,
      plotAreaSqft: plotAreaSqft ?? this.plotAreaSqft,
      buildingAreaSqft: buildingAreaSqft ?? this.buildingAreaSqft,
      formattedPrice: formattedPrice ?? this.formattedPrice,
      priceRange: priceRange ?? this.priceRange,
      bhkList: bhkList ?? this.bhkList,
      bathroomList: bathroomList ?? this.bathroomList,
      areaRange: areaRange ?? this.areaRange,
      image: image ?? this.image,
      imagesCount: imagesCount ?? this.imagesCount,
      amenities: amenities ?? this.amenities,
      media: media ?? this.media,
      isFavorited: isFavorited ?? this.isFavorited,
      shareData: shareData ?? this.shareData,
    );
  }
}

class PriceRange {
  final String min;
  final String max;

  PriceRange({required this.min, required this.max});

  factory PriceRange.fromJson(Map<String, dynamic> json) {
    return PriceRange(
      min: toStr(json['min']) ?? '',
      max: toStr(json['max']) ?? '',
    );
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
    return Amenity(id: toInt(json['id']) ?? 0, name: toStr(json['name']) ?? '');
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
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => MediaItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      videos:
          (json['videos'] as List<dynamic>?)
              ?.map((e) => MediaItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      documents:
          (json['documents'] as List<dynamic>?)
              ?.map((e) => MediaItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
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
      id: toInt(json['id']) ?? 0,
      url: "${Environments.baseUrl}${toStr(json['url'])}",
      fileType: toStr(json['file_type']) ?? '',
      documentType: toStr(json['document_type']),
      mediaLevel: toStr(json['media_level']) ?? '',
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
      title: toStr(json['title']) ?? '',
      message: toStr(json['message']) ?? '',
      image: toStr(json['image']) ?? '',
      url: toStr(json['url']) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'message': message, 'image': image, 'url': url};
  }
}
