class UserModel {
  final int id;
  final String? email;
  final String? phone;
  final String? countryCode;
  final String? fullName;
  final String? profileImage;
  final bool emailVerified;
  final bool phoneVerified;
  final List<String> roles;

  UserModel({
    required this.id,
    this.email,
    this.phone,
    this.countryCode,
    this.fullName,
    this.profileImage,
    required this.emailVerified,
    required this.phoneVerified,
    required this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      email: json['email'],
      phone: json['phone'],
      countryCode: json['country_code'],
      fullName: json['full_name'],
      profileImage: json['profile_image'],
      emailVerified: json['email_verified'] ?? false,
      phoneVerified: json['phone_verified'] ?? false,
      roles: json['roles'] != null ? List<String>.from(json['roles']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'country_code': countryCode,
      'full_name': fullName,
      'profile_image': profileImage,
      'email_verified': emailVerified,
      'phone_verified': phoneVerified,
      'roles': roles,
    };
  }
}
