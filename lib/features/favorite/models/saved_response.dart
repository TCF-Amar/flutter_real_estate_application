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
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      isFavorite: json['is_favorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'is_favorite': isFavorite};
  }
}
