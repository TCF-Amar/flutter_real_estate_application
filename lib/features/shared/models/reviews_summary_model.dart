import 'package:real_estate_app/core/utils/safe_parser.dart';

class ReviewsSummaryModel {
  final int? totalReviews;
  final num? averageRating;
  final RatingBreakdown? ratingBreakdown;

  const ReviewsSummaryModel({
    this.totalReviews,
    this.averageRating,
    this.ratingBreakdown,
  });

  factory ReviewsSummaryModel.fromJson(Map<String, dynamic> json) {
    try {
      return ReviewsSummaryModel(
        totalReviews: toInt(json['total_reviews']),
        averageRating: toDouble(json['average_rating']),
        ratingBreakdown: json['rating_breakdown'] != null
            ? RatingBreakdown.fromJson(
                json['rating_breakdown'] is Map<String, dynamic>
                    ? json['rating_breakdown'] as Map<String, dynamic>
                    : {},
              )
            : null,
      );
    } catch (_) {
      return const ReviewsSummaryModel(
        totalReviews: null,
        averageRating: null,
        ratingBreakdown: null,
      );
    }
  }

  Map<String, dynamic> toJson() => {
    'total_reviews': totalReviews,
    'average_rating': averageRating,
    'rating_breakdown': ratingBreakdown?.toJson(),
  };
}

class RatingBreakdown {
  final int? one;
  final int? two;
  final int? three;
  final int? four;
  final int? five;

  const RatingBreakdown({this.one, this.two, this.three, this.four, this.five});

  factory RatingBreakdown.fromJson(Map<String, dynamic> json) {
    try {
      return RatingBreakdown(
        one: toInt(json['1']),
        two: toInt(json['2']),
        three: toInt(json['3']),
        four: toInt(json['4']),
        five: toInt(json['5']),
      );
    } catch (_) {
      return const RatingBreakdown(
        one: null,
        two: null,
        three: null,
        four: null,
        five: null,
      );
    }
  }

  Map<String, dynamic> toJson() => {
    '1': one,
    '2': two,
    '3': three,
    '4': four,
    '5': five,
  };

  Map<int, int> toMap() => {
    1: one ?? 0,
    2: two ?? 0,
    3: three ?? 0,
    4: four ?? 0,
    5: five ?? 0,
  };
}
