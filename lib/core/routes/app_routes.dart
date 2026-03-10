class AppRoutes {
  AppRoutes._();

  /// Splash & Onboarding
  static const String splash = '/splash';
  static const String getStart = '/get-start';

  /// Auth Routes
  static const String auth = '/auth';
  static const String signin = '$auth/signin';
  static const String signup = '$auth/signup';
  static const String verifyCode = '$auth/verify-code';
  static const String forgotPassword = '$auth/forgot-password';
  static const String resetPassword = '$auth/reset-password';
  static const String selectCountry = '$auth/select-country';

  /// Main Navigation
  static const String main = '/main';

  /// Search
  static const String search = '/search';
  static const String searchResult = '/search-result';

  /// Property
  static const String propertyDetails = '/property-details';

  /// Agent
  static const String agentDetails = '/agent-details';

  /// Profile
  static const String profile = '/profile';
  static const String editProfile = '$profile/edit-profile';

  /// Support
  static const String support = '$profile/support';
  static const String newRequest = '$support/new-request';
  static const String supportDetails = '$support/support-details';

  // account detection
  static const String accountDelete = '/account-delete';
}
