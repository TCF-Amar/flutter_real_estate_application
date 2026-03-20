class MaintenanceRequestModel {
  final int id;
  final String requestNumber;
  final String title;
  final String category;
  final String priority;
  final String status;
  final MaintenanceProperty? property;
  final int imagesCount;
  final bool hasFeedback;
  final String createdAt;

  MaintenanceRequestModel({
    required this.id,
    required this.requestNumber,
    required this.title,
    required this.category,
    required this.priority,
    required this.status,
    this.property,
    required this.imagesCount,
    required this.hasFeedback,
    required this.createdAt,
  });

  factory MaintenanceRequestModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceRequestModel(
      id: json['id'] ?? 0,
      requestNumber: json['request_number'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      priority: json['priority'] ?? '',
      status: json['status'] ?? '',
      property: json['property'] != null
          ? MaintenanceProperty.fromJson(json['property'])
          : null,
      imagesCount: json['images_count'] ?? 0,
      hasFeedback: json['has_feedback'] ?? false,
      createdAt: json['created_at'] ?? '',
    );
  }
}

class MaintenanceProperty {
  final int id;
  final String title;
  final String location;
  final String image;

  MaintenanceProperty({
    required this.id,
    required this.title,
    required this.location,
    required this.image,
  });

  factory MaintenanceProperty.fromJson(Map<String, dynamic> json) {
    return MaintenanceProperty(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
