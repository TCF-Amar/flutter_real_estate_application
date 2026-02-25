import 'package:real_estate_app/core/constants/environments.dart';
import 'package:real_estate_app/core/utils/safe_parser.dart';
import 'package:real_estate_app/features/explore/models/agent_details_response_model.dart';

class AgentModel {
  final int id;
  final String name;
  final String image;
  final String agencyName;
  final String location;
  final String experience;
  final String roleType;
  final double rating;
  final int reviewCount;
  final int propertiesCount;
  final String description;

  AgentModel({
    required this.id,
    required this.name,
    required this.image,
    required this.agencyName,
    required this.location,
    required this.experience,
    required this.roleType,
    required this.rating,
    required this.reviewCount,
    required this.propertiesCount,
    required this.description,
  });

  factory AgentModel.fromJson(Map<String, dynamic> json) {
    return AgentModel(
      id: toInt(json['id']) ?? 0,
      name: toStr(json['name']) ?? '',
      image: "${Environments.baseUrl}${toStr(json['image'])}",
      agencyName: toStr(json['agency_name']) ?? '',
      location: toStr(json['location']) ?? '',
      experience: toStr(json['experience']) ?? '',
      roleType: toStr(json['role_type']) ?? '',
      rating: toDouble(json['rating']) ?? 0.0,
      reviewCount: toInt(json['review_count']) ?? 0,
      propertiesCount: toInt(json['properties_count']) ?? 0,
      description: toStr(json['description']) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'agency_name': agencyName,
      'location': location,
      'experience': experience,
      'role_type': roleType,
      'rating': rating,
      'review_count': reviewCount,
      'properties_count': propertiesCount,
      'description': description,
    };
  }

  // entity
  factory AgentModel.fromEntity(AgentDetailModel entity) {
    return AgentModel(
      id: entity.id,
      name: entity.name,
      image: entity.image!,
      agencyName: entity.agencyName,
      location: entity.location!,
      experience: entity.experience!,
      roleType: entity.roleType,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      propertiesCount: entity.propertiesCount,
      description: entity.description!,
    );
  }
}
