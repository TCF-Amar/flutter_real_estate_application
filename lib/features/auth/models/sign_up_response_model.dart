class SignUpResponseModel {
  final bool status;
  final String message;
  final OtpDataModel data;
  final String? otp; // production me ideally remove

  SignUpResponseModel({
    required this.status,
    required this.message,
    required this.data,
    this.otp,
  });

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) {
    return SignUpResponseModel(
      status: json['status'],
      message: json['message'],
      data: OtpDataModel.fromJson(json['data']),
      otp: json['otp'],
    );
  }
}

class OtpDataModel {
  final String email;
  final String userType;

  OtpDataModel({required this.email, required this.userType});

  factory OtpDataModel.fromJson(Map<String, dynamic> json) {
    return OtpDataModel(email: json['email'], userType: json['user_type']);
  }
}
