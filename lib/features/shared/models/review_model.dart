import 'package:real_estate_app/core/constants/environments.dart';
import 'package:real_estate_app/core/utils/safe_parser.dart';

class ReviewModel {
  final int id;
  final int rating;
  final String comment;
  final String createdAt;
  final String reviewerName;
  final String? reviewerImage;
  final int reviewerId;
  final bool isMine;

  ReviewModel({
    required this.id,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.reviewerName,
    this.reviewerImage,
    required this.reviewerId,
    required this.isMine,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: toInt(json['id']) ?? 0,
      rating: toInt(json['rating']) ?? 0,
      comment: toStr(json['comment']) ?? '',
      createdAt: toStr(json['created_at']) ?? '',
      reviewerName: toStr(json['reviewer_name']) ?? '',
      reviewerImage: "${Environments.baseUrl}${toStr(json['reviewer_image'])}",
      reviewerId: toInt(json['reviewer_id']) ?? 0,
      isMine: json['is_mine'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt,
      'reviewer_name': reviewerName,
      'reviewer_image': reviewerImage,
      'reviewer_id': reviewerId,
      'is_mine': isMine,
    };
  }
}
