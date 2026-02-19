class ProfileModel {
  final int id;
  final int userId;
  final String? country;
  final int locationAccess;
  final String appLanguage;
  final int onboardingStep;
  final bool onboardingCompleted;
  final DateTime? onboardingCompletedAt;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfileModel({
    required this.id,
    required this.userId,
    this.country,
    required this.locationAccess,
    required this.appLanguage,
    required this.onboardingStep,
    required this.onboardingCompleted,
    this.onboardingCompletedAt,
    this.profileImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      userId: json['user_id'],
      country: json['country'],
      locationAccess: json['location_access'],
      appLanguage: json['app_language'],
      onboardingStep: json['onboarding_step'],
      onboardingCompleted: json['onboarding_completed'] ?? false,
      onboardingCompletedAt: json['onboarding_completed_at'] != null
          ? DateTime.parse(json['onboarding_completed_at'])
          : null,
      profileImage: json['profile_image'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
