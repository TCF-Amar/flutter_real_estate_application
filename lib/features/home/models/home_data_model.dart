import 'package:real_estate_app/features/explore/models/property_model.dart';

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

