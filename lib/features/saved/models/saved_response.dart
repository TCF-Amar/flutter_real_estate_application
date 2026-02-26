class SavedResponse {
  final bool status;
  final String message;
  final bool isFavorite;

  SavedResponse({
    required this.status,
    required this.message,
    required this.isFavorite,
  });

  factory SavedResponse.fromJson(Map<String, dynamic> json) {
    return SavedResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      isFavorite: json['is_favorite'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'is_favorite': isFavorite};
  }
}
