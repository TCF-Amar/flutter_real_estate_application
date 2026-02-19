import 'package:real_estate_app/features/auth/models/onboarding_model.dart';
import 'package:real_estate_app/features/shared/models/profile_model.dart';
import 'package:real_estate_app/features/shared/models/user_model.dart';

class CurrentUserModel {
  final bool status;
  final ResponseData data;

  CurrentUserModel({required this.status, required this.data});

  factory CurrentUserModel.fromJson(Map<String, dynamic> json) {
    return CurrentUserModel(
      status: json['status'] ?? false,
      data: ResponseData.fromJson(json['data']),
    );
  }
}

class ResponseData {
  final UserModel user;
  final ProfileModel profile;
  final OnboardingModel onboarding;
  final bool onboardCompleted;
  final String approvalStatus;
  final String? accessLevel;

  ResponseData({
    required this.user,
    required this.profile,
    required this.onboarding,
    required this.onboardCompleted,
    required this.approvalStatus,
    this.accessLevel,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      user: UserModel.fromJson(json['user']),
      profile: ProfileModel.fromJson(json['profile']),
      onboarding: OnboardingModel.fromJson(json['onboarding']),
      onboardCompleted: json['onboard_completed'] ?? false,
      approvalStatus: json['approval_status'],
      accessLevel: json['access_level'],
    );
  }
}
