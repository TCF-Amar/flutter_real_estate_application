class BasicInfoUpdateModel {
  final String fullName;
  final String email;
  final String phone;

  BasicInfoUpdateModel({
    required this.fullName,
    required this.email,
    required this.phone,
  });

  factory BasicInfoUpdateModel.fromJson(Map<String, dynamic> json) {
    return BasicInfoUpdateModel(
      fullName: json['full_name'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}
