class SignUpRequestModel {
  final String fullName;
  final String email;
  final String phone;
  final String countryCode;
  final String password;
  final String passwordConfirmation;

  SignUpRequestModel({
    required this.fullName,
    required this.email,
    required this.phone,
    this.countryCode = "91",
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      "full_name": fullName,
      "email": email,
      "phone": phone,
      "country_code": countryCode,
      "password": password,
      "password_confirmation": passwordConfirmation,
    };
  }
}
