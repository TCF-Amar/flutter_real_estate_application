class PropertyInquiryReqModel {
  int pId;
  final String name;
  final String email;
  final String phone;
  final String message;

  PropertyInquiryReqModel({
    required this.pId,
    required this.name,
    required this.email,
    required this.phone,
    required this.message,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "phone": phone,
    "message": message,
  };
}
