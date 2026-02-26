class ReviewRequestModel {
  final int rating;
  final String? title;
  final String? comment;

  ReviewRequestModel({required this.rating, this.title, this.comment});

  Map<String, dynamic> toJson() => {
    "rating": rating,
    "title": title,
    "comment": comment,
  };
}
