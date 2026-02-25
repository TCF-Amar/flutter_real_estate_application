import 'package:real_estate_app/core/utils/safe_parser.dart';

class ContactModel {
  final String? name;
  final String? company;
  final int? agentId;
  final String? type;
  final String? profileImage;
  final double? avgRating;
  final int? reviewCount;
  final String? experience;
  final int? propertiesCount;

  const ContactModel({
    this.name,
    this.company,
    this.agentId,
    this.type,
    this.profileImage,
    this.avgRating,
    this.reviewCount,
    this.experience,
    this.propertiesCount,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
    name: toStr(json['name']),
    company: toStr(json['company']),
    agentId: toInt(json['agent_id']),
    type: toStr(json['type']),
    profileImage: toStr(json['profile_image']),
    avgRating: toDouble(json['avg_rating']),
    reviewCount: toInt(json['review_count']),
    experience: toStr(json['experience']),
    propertiesCount: toInt(json['properties_count']),
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'company': company,
    'agent_id': agentId,
    'type': type,
    'profile_image': profileImage,
    'avg_rating': avgRating,
    'review_count': reviewCount,
    'experience': experience,
    'properties_count': propertiesCount,
  };
}
