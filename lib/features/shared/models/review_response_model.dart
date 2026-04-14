import 'dart:convert';
import 'package:real_estate_app/features/shared/models/pagination_model.dart';
import 'package:real_estate_app/features/shared/models/review_model.dart';
import 'package:real_estate_app/features/shared/models/reviews_summary_model.dart';

class ReviewResponse {
  final bool status;
  final ReviewData data;

  ReviewResponse({required this.status, required this.data});

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      status: json['status'] as bool,
      data: ReviewData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'data': data.toJson()};
  }

  factory ReviewResponse.fromRawJson(String str) =>
      ReviewResponse.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());
}

class ReviewData {
  final ReviewSummaryModel reviewsSummary;
  final List<ReviewModel> reviews;
  final PaginationModel pagination;

  ReviewData({
    required this.reviewsSummary,
    required this.reviews,
    required this.pagination,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      reviewsSummary: json['reviews_summary'] != null
          ? ReviewSummaryModel.fromJson(
              json['reviews_summary'] is Map<String, dynamic>
                  ? json['reviews_summary'] as Map<String, dynamic>
                  : {},
            )
          : ReviewSummaryModel.empty(),
      reviews: (json['reviews'] as List?)
              ?.map((e) => e is Map<String, dynamic>
                  ? ReviewModel.fromJson(e)
                  : ReviewModel.fromJson({}))
              .toList() ??
          [],
      pagination: json['pagination'] != null
          ? PaginationModel.fromJson(
              json['pagination'] is Map<String, dynamic>
                  ? json['pagination'] as Map<String, dynamic>
                  : {},
            )
          : PaginationModel.empty(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviews_summary': reviewsSummary.toJson(),
      'reviews': reviews.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}
