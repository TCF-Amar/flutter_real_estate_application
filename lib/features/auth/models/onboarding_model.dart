class OnboardingModel {
  final int step;
  final bool completed;
  final String? role;
  final String? verificationStatus;

  OnboardingModel({
    required this.step,
    required this.completed,
    this.role,
    this.verificationStatus,
  });

  factory OnboardingModel.fromJson(Map<String, dynamic> json) {
    return OnboardingModel(
      step: json['step'] ?? 0,
      completed: json['completed'] ?? false,
      role: json['role'],
      verificationStatus: json['verification_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'step': step,
      'completed': completed,
      'role': role,
      'verification_status': verificationStatus,
    };
  }
}
