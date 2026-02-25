import 'package:real_estate_app/core/constants/environments.dart';
import 'package:real_estate_app/core/utils/safe_parser.dart';
import 'package:real_estate_app/features/explore/models/agent_model.dart';
import 'package:real_estate_app/features/explore/models/property_model.dart';
import 'package:real_estate_app/features/explore/models/review_model.dart';

class AgentDetailsResponse {
  final bool status;
  final AgentDetailModel data;

  AgentDetailsResponse({required this.status, required this.data});

  factory AgentDetailsResponse.fromJson(Map<String, dynamic> json) {
    return AgentDetailsResponse(
      status: json['status'] is bool ? json['status'] as bool : false,
      data: AgentDetailModel.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'data': data.toJson()};
  }
}

class AgentDetailModel {
  final int id;
  final String name;
  final String? image;
  final String email;
  final String phone;
  final String agencyName;
  final String roleType;
  final String? licenseNumber;
  final String? experience;
  final String? location;
  final String? specialities;
  final String? taxNumber;
  final String? description;
  final double rating;
  final int reviewCount;
  final List<ReviewModel> reviews;
  final int propertiesCount;
  final List<Property> properties;

  AgentDetailModel({
    required this.id,
    required this.name,
    this.image,
    required this.email,
    required this.phone,
    required this.agencyName,
    required this.roleType,
    this.licenseNumber,
    this.experience,
    this.location,
    this.specialities,
    this.taxNumber,
    this.description,
    required this.rating,
    required this.reviewCount,
    required this.reviews,
    required this.propertiesCount,
    required this.properties,
  });

  factory AgentDetailModel.fromJson(Map<String, dynamic> json) {
    try {
      final imagePath = toStr(json['image']);
      return AgentDetailModel(
        id: toInt(json['id']) ?? 0,
        name: toStr(json['name']) ?? '',
        image: imagePath != null && imagePath.isNotEmpty
            ? "${Environments.baseUrl}$imagePath"
            : null,
        email: toStr(json['email']) ?? '',
        phone: toStr(json['phone']) ?? '',
        agencyName: toStr(json['agency_name']) ?? '',
        roleType: toStr(json['role_type']) ?? '',
        licenseNumber: toStr(json['license_number']),
        experience: toStr(json['experience']),
        location: toStr(json['location']),
        specialities: toStr(json['specialities']),
        taxNumber: toStr(json['tax_number']),
        description: toStr(json['description']),
        rating: toDouble(json['rating']) ?? 0.0,
        reviewCount: toInt(json['review_count']) ?? 0,
        reviews: (json['reviews'] is List)
            ? (json['reviews'] as List<dynamic>)
                  .map(
                    (e) => ReviewModel.fromJson(
                      e is Map<String, dynamic> ? e : {},
                    ),
                  )
                  .toList()
            : [],
        propertiesCount: toInt(json['properties_count']) ?? 0,
        properties: (json['properties'] is List)
            ? (json['properties'] as List<dynamic>)
                  .map(
                    (e) =>
                        Property.fromJson(e is Map<String, dynamic> ? e : {}),
                  )
                  .toList()
            : [],
      );
    } catch (e) {
      // Return empty/default model on parsing error
      return AgentDetailModel(
        id: 0,
        name: '',
        image: null,
        email: '',
        phone: '',
        agencyName: '',
        roleType: '',
        licenseNumber: null,
        experience: null,
        location: null,
        specialities: null,
        taxNumber: null,
        description: null,
        rating: 0.0,
        reviewCount: 0,
        reviews: [],
        propertiesCount: 0,
        properties: [],
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'email': email,
      'phone': phone,
      'agency_name': agencyName,
      'role_type': roleType,
      'license_number': licenseNumber,
      'experience': experience,
      'location': location,
      'specialities': specialities,
      'tax_number': taxNumber,
      'description': description,
      'rating': rating,
      'review_count': reviewCount,
      'reviews': reviews.map((e) => e.toJson()).toList(),
      'properties_count': propertiesCount,
      'properties': properties.map((e) => e.toJson()).toList(),
    };
  }

  AgentModel? toAgentModel() {
    try {
      return AgentModel(
        id: id,
        name: name,
        image: image ?? '',
        agencyName: agencyName,
        location: location ?? '',
        experience: experience ?? '',
        roleType: roleType,
        rating: rating,
        reviewCount: reviewCount,
        propertiesCount: propertiesCount,
        description: description ?? '',
      );
    } catch (_) {
      return null;
    }
  }
}
