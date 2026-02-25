import 'package:real_estate_app/features/explore/models/property_detail_model.dart';

class PropertyDetailResponseModel {
  final bool status;
  final PropertyDetail? data;

  const PropertyDetailResponseModel({required this.status, this.data});

  factory PropertyDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return PropertyDetailResponseModel(
      status: json['status'] as bool? ?? false,
      data: json['data'] != null
          ? PropertyDetail.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {'status': status, 'data': data?.toJson()};
}
