// homepage_models.dart

import 'package:real_estate_app/features/home/models/home_data_model.dart';

class HomepageResponse {
  final bool status;
  final HomepageData data;

  HomepageResponse({required this.status, required this.data});

  factory HomepageResponse.fromJson(Map<String, dynamic> json) {
    return HomepageResponse(
      status: json['status'] as bool,
      data: HomepageData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'data': data.toJson()};
  }
}



