import 'package:real_estate_app/features/shared/models/pagination_model.dart';

enum MaintenanceStatus {
  open,
  assigned,
  inProgress,
  completed,
  closed;

  String get label {
    switch (this) {
      case MaintenanceStatus.open:
        return "Open";
      case MaintenanceStatus.assigned:
        return "Assigned";
      case MaintenanceStatus.inProgress:
        return "In Progress";
      case MaintenanceStatus.completed:
        return "Completed";
      case MaintenanceStatus.closed:
        return "Closed";
    }
  }

  /// Parse from API response, handling both snake_case and camelCase
  static MaintenanceStatus fromApi(dynamic value) {
    if (value == null) return open;
    final normalized = value.toString().toLowerCase();
    // Handle snake_case variants from API
    if (normalized == 'in_progress') return inProgress;
    // Match enum name directly
    return MaintenanceStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == normalized,
      orElse: () => open,
    );
  }
}

class MaintenanceRequestModel {
  final int id;
  final String requestNumber;
  final String title;
  final String category;
  final String priority;
  final MaintenanceStatus status;
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
      status: MaintenanceStatus.fromApi(json['status']),
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

class MaintenanceResponse {
  final bool status;
  final MaintenanceData data;

  MaintenanceResponse({required this.status, required this.data});

  factory MaintenanceResponse.fromJson(Map<String, dynamic> json) {
    return MaintenanceResponse(
      status: json['status'] ?? false,
      data: MaintenanceData.fromJson(json['data'] ?? {}),
    );
  }
}

class MaintenanceData {
  final List<MaintenanceRequestModel> requests;
  final PaginationModel pagination;

  MaintenanceData({required this.requests, required this.pagination});

  factory MaintenanceData.fromJson(Map<String, dynamic> json) {
    return MaintenanceData(
      requests:
          (json['requests'] as List?)
              ?.map((e) => MaintenanceRequestModel.fromJson(e))
              .toList() ??
          [],
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }
}

class MaintenanceDetailResponse {
  final bool status;
  final MaintenanceDetailModel data;

  MaintenanceDetailResponse({required this.status, required this.data});

  factory MaintenanceDetailResponse.fromJson(Map<String, dynamic> json) {
    return MaintenanceDetailResponse(
      status: json['status'] ?? false,
      data: MaintenanceDetailModel.fromJson(json['data'] ?? {}),
    );
  }
}

class MaintenanceDetailModel {
  final int id;
  final String requestNumber;
  final String title;
  final String description;
  final String category;
  final String priority;
  final MaintenanceStatus status;
  final MaintenanceProperty? property;
  final MaintenanceMedia media;
  final MaintenanceTechnician? assignedTo;
  final String? feedback;
  final String? scheduledDate;
  final String? completedDate;
  final String createdAt;
  final String updatedAt;

  MaintenanceDetailModel({
    required this.id,
    required this.requestNumber,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    this.property,
    required this.media,
    this.assignedTo,
    this.feedback,
    this.scheduledDate,
    this.completedDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MaintenanceDetailModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceDetailModel(
      id: json['id'] ?? 0,
      requestNumber: json['request_number'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      priority: json['priority'] ?? '',
      status: MaintenanceStatus.fromApi(json['status']),
      property: json['property'] != null
          ? MaintenanceProperty.fromJson(json['property'])
          : null,
      media: json['media'] != null
          ? MaintenanceMedia.fromJson(json['media'])
          : MaintenanceMedia(images: [], videos: []),
      assignedTo: json['assigned_to'] != null
          ? MaintenanceTechnician.fromJson(json['assigned_to'])
          : null,
      feedback: json['feedback'],
      scheduledDate: json['scheduled_date'],
      completedDate: json['completed_date'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class MaintenanceMedia {
  final List<MediaItem> images;
  final List<MediaItem> videos;

  MaintenanceMedia({required this.images, required this.videos});

  factory MaintenanceMedia.fromJson(Map<String, dynamic> json) {
    return MaintenanceMedia(
      images:
          (json['images'] as List?)?.map((e) => MediaItem.fromJson(e)).toList() ??
          [],
      videos:
          (json['videos'] as List?)?.map((e) => MediaItem.fromJson(e)).toList() ??
          [],
    );
  }
}

class MediaItem {
  final int id;
  final String url;

  MediaItem({required this.id, required this.url});

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      id: json['id'] ?? 0,
      url: json['url'] ?? '',
    );
  }
}

class MaintenanceTechnician {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String profileImage;

  MaintenanceTechnician({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.profileImage,
  });

  factory MaintenanceTechnician.fromJson(Map<String, dynamic> json) {
    return MaintenanceTechnician(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profile_image'] ?? '',
    );
  }
}
