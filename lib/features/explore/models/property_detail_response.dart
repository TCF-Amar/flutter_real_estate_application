import 'package:real_estate_app/features/explore/models/property_detail.dart';

class PropertyDetailResponse {
  final bool status;
  final PropertyDetail? data;

  const PropertyDetailResponse({required this.status, this.data});

  factory PropertyDetailResponse.fromJson(Map<String, dynamic> json) {
    return PropertyDetailResponse(
      status: json['status'] as bool? ?? false,
      data: json['data'] != null
          ? PropertyDetail.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {'status': status, 'data': data?.toJson()};
}
