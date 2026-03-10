import 'package:real_estate_app/core/constants/environments.dart';
import 'package:real_estate_app/core/utils/safe_parser.dart';
import 'package:real_estate_app/features/agent/models/agent_details_response_model.dart';

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
  final bool isFavorited;

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
    this.isFavorited = false,
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
      isFavorited: json['is_favorited'] ?? false,
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

  AgentModel copyWith({
    int? id,
    String? name,
    String? image,
    String? agencyName,
    String? location,
    String? experience,
    String? roleType,
    double? rating,
    int? reviewCount,
    int? propertiesCount,
    String? description,
    bool? isFavorited,
  }) {
    return AgentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      agencyName: agencyName ?? this.agencyName,
      location: location ?? this.location,
      experience: experience ?? this.experience,
      roleType: roleType ?? this.roleType,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      propertiesCount: propertiesCount ?? this.propertiesCount,
      description: description ?? this.description,
      isFavorited: isFavorited ?? this.isFavorited,
    );
  }

  factory AgentModel.fromAgentDetailModel(AgentDetailModel agent) {
    return AgentModel(
      id: agent.id,
      name: agent.name,
      image: agent.image!,
      agencyName: agent.agencyName,
      location: agent.location!,
      experience: agent.experience!,
      roleType: agent.roleType,
      rating: agent.rating,
      reviewCount: agent.reviewCount,
      propertiesCount: agent.propertiesCount,
      description: agent.description!,
    );
  }
}
