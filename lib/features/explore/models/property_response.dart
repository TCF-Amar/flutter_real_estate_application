import 'package:real_estate_app/core/utils/safe_parser.dart';
import 'package:real_estate_app/features/explore/models/property_model.dart';

class PropertyResponse {
  final bool status;
  final List<Property> data;
  final Pagination? pagination;

  PropertyResponse({required this.status, required this.data, this.pagination});

  factory PropertyResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    List<Property> properties = [];
    Pagination? pagination;

    if (rawData is Map) {
      if (rawData['properties'] is List) {
        properties = (rawData['properties'] as List)
            .map((e) => Property.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      if (rawData['pagination'] is Map) {
        pagination = Pagination.fromJson(rawData['pagination']);
      }
    } else if (rawData is List) {
      properties = rawData
          .map((e) => Property.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return PropertyResponse(
      status: json['status'] ?? false,
      data: properties,
      pagination: pagination,
    );
  }
}

class Pagination {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  Pagination({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: toInt(json['current_page']) ?? 0,
      lastPage: toInt(json['last_page']) ?? 0,
      perPage: toInt(json['per_page']) ?? 0,
      total: toInt(json['total']) ?? 0,
    );
  }
}
