import 'package:real_estate_app/features/auth/models/onboarding_model.dart';
import 'package:real_estate_app/features/shared/models/user_model.dart';

class AuthDataModel {
  final UserModel user;
  final OnboardingModel onboarding;

  final bool? onboardingCompleted;
  final bool? emailVerified;

  final String approvalStatus;
  final String? accessLevel;

  final String token;
  final String refreshToken;
  final DateTime expiresAt;

  AuthDataModel({
    required this.user,
    required this.onboarding,
    this.onboardingCompleted,
    this.emailVerified,
    required this.approvalStatus,
    this.accessLevel,
    required this.token,
    required this.refreshToken,
    required this.expiresAt,
  });

  factory AuthDataModel.fromJson(Map<String, dynamic> json) {
    return AuthDataModel(
      user: UserModel.fromJson(json['user']),
      onboarding: OnboardingModel.fromJson(json['onboarding']),
      onboardingCompleted: json['onboarding_completed'],
      emailVerified: json['email_verified'],
      approvalStatus: json['approval_status'],
      accessLevel: json['access_level'],
      token: json['token'],
      refreshToken: json['refresh_token'],
      expiresAt: DateTime.parse(json['expires_at']),
    );
  }
}
