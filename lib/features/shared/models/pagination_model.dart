import 'package:real_estate_app/core/utils/safe_parser.dart';

class PaginationModel {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PaginationModel({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: toInt(json['current_page']) ?? 0,
      lastPage: toInt(json['last_page']) ?? 0,
      perPage: toInt(json['per_page']) ?? 0,
      total: toInt(json['total']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
    };
  }
}
