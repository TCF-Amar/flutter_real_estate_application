import 'package:real_estate_app/features/auth/models/auth_data_model.dart';

class AuthResponse {
  final bool status;
  final String message;
  final AuthDataModel? data;

  AuthResponse({required this.status, required this.message, this.data});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? AuthDataModel.fromJson(json['data']) : null,
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {'status': status, 'message': message, 'data': data?.toJson()};
  // }
}
