import 'package:real_estate_app/features/property/models/property_detail_model.dart';
import 'package:real_estate_app/features/property/models/property_model.dart';

class FavoriteProperty {
  final int? id;
  final String? title;
  final String? propertyCategory;
  final String? propertyType;
  final String? listingCategory;
  final String? city;
  final String? state;
  final String? formattedPrice;
  final String? image;
  final bool? isFavorited;

  FavoriteProperty({
    this.id,
    this.title,
    this.propertyCategory,
    this.propertyType,
    this.listingCategory,
    this.city,
    this.state,
    this.formattedPrice,
    this.image,
    this.isFavorited,
  });

  factory FavoriteProperty.fromJson(Map<String, dynamic> json) {
    return FavoriteProperty(
      id: json['id'] as int?,
      title: json['title'] as String?,
      propertyCategory: json['property_category'] as String?,
      propertyType: json['property_type'] as String?,
      listingCategory: json['listing_category'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      formattedPrice: json['formatted_price'] as String?,
      image: json['image'] as String?,
      isFavorited: json['is_favorited'] as bool?,
    );
  }

  factory FavoriteProperty.fromProperty(Property property) {
    return FavoriteProperty(
      id: property.id,
      title: property.title,
      propertyCategory: property.propertyCategory,
      propertyType: property.propertyType,
      listingCategory: property.listingCategory,
      city: property.city,
      state: property.state,
      formattedPrice: property.formattedPrice,
      image: property.image,
      isFavorited: property.isFavorited,
    );
  }

  factory FavoriteProperty.fromPropertyDetails(PropertyDetail property) {
    return FavoriteProperty(
      id: property.id,
      title: property.title,
      propertyCategory: property.propertyCategory,
      propertyType: property.propertyType,
      listingCategory: property.listingCategory,
      city: property.address!.city,
      state: property.address!.state,
      formattedPrice: property.formattedPrice,
      image: property.media!.images.first.url,
      isFavorited: property.isFavorited,
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
      'formatted_price': formattedPrice,
      'image': image,
      'is_favorited': isFavorited,
    };
  }
}
