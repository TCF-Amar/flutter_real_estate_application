
import 'package:real_estate_app/core/utils/safe_parser.dart';

class ReviewModel {
  final int id;
  final int reviewerUserId;
  final String reviewableType;
  final int reviewableId;
  final int rating;
  final String comment;
  final int isVerifiedPurchase;
  final int isApproved;
  final String createdAt;
  final String updatedAt;
  final ReviewerModel reviewer;

  ReviewModel({
    required this.id,
    required this.reviewerUserId,
    required this.reviewableType,
    required this.reviewableId,
    required this.rating,
    required this.comment,
    required this.isVerifiedPurchase,
    required this.isApproved,
    required this.createdAt,
    required this.updatedAt,
    required this.reviewer,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    try {
      return ReviewModel(
        id: toInt(json['id']) ?? 0,
        reviewerUserId: toInt(json['reviewer_user_id']) ?? 0,
        reviewableType: toStr(json['reviewable_type']) ?? '',
        reviewableId: toInt(json['reviewable_id']) ?? 0,
        rating: toInt(json['rating']) ?? 0,
        comment: toStr(json['comment']) ?? '',
        isVerifiedPurchase: toInt(json['is_verified_purchase']) ?? 0,
        isApproved: toInt(json['is_approved']) ?? 0,
        createdAt: toStr(json['created_at']) ?? '',
        updatedAt: toStr(json['updated_at']) ?? '',
        reviewer: ReviewerModel.fromJson(
          json['reviewer'] is Map<String, dynamic>
              ? json['reviewer'] as Map<String, dynamic>
              : {},
        ),
      );
    } catch (_) {
      return ReviewModel(
        id: 0,
        reviewerUserId: 0,
        reviewableType: '',
        reviewableId: 0,
        rating: 0,
        comment: '',
        isVerifiedPurchase: 0,
        isApproved: 0,
        createdAt: '',
        updatedAt: '',
        reviewer: ReviewerModel(
          id: 0,
          fullName: '',
          email: '',
          buyerProfile: null,
        ),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reviewer_user_id': reviewerUserId,
      'reviewable_type': reviewableType,
      'reviewable_id': reviewableId,
      'rating': rating,
      'comment': comment,
      'is_verified_purchase': isVerifiedPurchase,
      'is_approved': isApproved,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'reviewer': reviewer.toJson(),
    };
  }
}



class ReviewerModel {
  final int id;
  final String fullName;
  final String email;
  final dynamic buyerProfile;

  ReviewerModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.buyerProfile,
  });

  factory ReviewerModel.fromJson(Map<String, dynamic> json) {
    try {
      return ReviewerModel(
        id: toInt(json['id']) ?? 0,
        fullName: toStr(json['full_name']) ?? '',
        email: toStr(json['email']) ?? '',
        buyerProfile: json['buyer_profile'],
      );
    } catch (_) {
      return ReviewerModel(
        id: 0,
        fullName: '',
        email: '',
        buyerProfile: null,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'buyer_profile': buyerProfile,
    };
  }
}
