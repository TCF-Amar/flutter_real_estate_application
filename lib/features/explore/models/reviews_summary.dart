class ReviewsSummary {
  final int? totalReviews;
  final num? averageRating;
  final RatingBreakdown? ratingBreakdown;

  const ReviewsSummary({
    this.totalReviews,
    this.averageRating,
    this.ratingBreakdown,
  });

  factory ReviewsSummary.fromJson(Map<String, dynamic> json) => ReviewsSummary(
    totalReviews: int.tryParse(json['total_reviews']?.toString() ?? ''),
    averageRating: num.tryParse(json['average_rating']?.toString() ?? ''),
    ratingBreakdown: json['rating_breakdown'] != null
        ? RatingBreakdown.fromJson(json['rating_breakdown'])
        : null,
  );

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

  factory RatingBreakdown.fromJson(Map<String, dynamic> json) =>
      RatingBreakdown(
        one: int.tryParse(json['1']?.toString() ?? ''),
        two: int.tryParse(json['2']?.toString() ?? ''),
        three: int.tryParse(json['3']?.toString() ?? ''),
        four: int.tryParse(json['4']?.toString() ?? ''),
        five: int.tryParse(json['5']?.toString() ?? ''),
      );

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
