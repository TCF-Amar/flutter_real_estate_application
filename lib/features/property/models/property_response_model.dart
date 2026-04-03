import 'package:real_estate_app/features/shared/models/pagination_model.dart';
import 'package:real_estate_app/features/property/models/property_model.dart';

class PropertyResponseModel {
  // final bool status;
  final List<Property> properties;
  final PaginationModel? pagination;

  PropertyResponseModel({ required this.properties, this.pagination});

  factory PropertyResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    List<Property> properties = [];
    PaginationModel? pagination;

    if (rawData is Map) {
      if (rawData['properties'] is List) {
        properties = (rawData['properties'] as List)
            .map((e) => Property.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      if (rawData['pagination'] is Map) {
        pagination = PaginationModel.fromJson(rawData['pagination']);
      }
    } else if (rawData is List) {
      properties = rawData
          .map((e) => Property.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return PropertyResponseModel(
      // status: json['status'] ?? false,
      properties: properties,
      pagination: pagination,
    );
  }
}



