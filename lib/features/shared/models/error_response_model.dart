class ErrorResponseModel {
  final bool status;
  final String message;
  final Map<String, List<String>> errors;

  ErrorResponseModel({
    required this.status,
    required this.message,
    required this.errors,
  });

  factory ErrorResponseModel.fromJson(Map<String, dynamic> json) {
    return ErrorResponseModel(
      status: json['status'],
      message: json['message'],
      errors: json['errors'] != null
          ? Map<String, List<String>>.from(
              json['errors'].map(
                (key, value) => MapEntry(key, List<String>.from(value)),
              ),
            )
          : {},
    );
  }
}
