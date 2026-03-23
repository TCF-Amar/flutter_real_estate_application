class AppRoutes {
  AppRoutes._();

  static const String test = '/';

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
  static const String property = '/property';
  static const String propertyDetails = '$property/details';
  static const String bookVisit = "$property/book-visit";
  static const String visitConfirmationPrev =
      '$property/visit-confirmation-prev';
  static const String visitBookingConfirm = '$property/visit-booking-confirm';
  static const String visitDetails = "$property/visit-details";

  /// Agent
  static const String agent = '/agent';
  static const String agentDetails = '$agent/details';

  /// Profile
  static const String profile = '/profile';
  static const String editProfile = '$profile/edit';
  static const String settings = '$profile/settings';

  /// Support
  static const String support = '$profile/support';
  static const String newRequest = '$support/request';
  static const String supportDetails = '$support/details';

  // account detection
  static const String accountDelete = '$profile/account/delete';

  static const String changePassword = "$profile/change-password";

  static String bookingDetails = "$profile/$property/booking/details";
  static const String transactionHistory = "$profile/transactions";
}
