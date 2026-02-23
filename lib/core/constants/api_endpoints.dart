class ApiEndpoints {
  //? Auth endpoints
  static const String _auth = "/auth";

  static const String login = "$_auth/login";
  static const String signUp = "$_auth/register/buyer";
  static const String verifyOtp = "$_auth/verify-otp";
  static const String resendOtp = "$_auth/resend-otp";
  static const String currentUser = "$_auth/me";
  static const String refreshToken = "$_auth/refresh";
  static const String logout = "$_auth/logout";
  static const String forgotPassword = "$_auth/forgot-password";
  static const String resetPassword = "$_auth/reset-password";

  //? onboarding buyer
  static const String _onboarding = "/onboarding";
  static const String buyerOnboarding = "$_onboarding/buyer";

  //? buyer
  static const String _buyer = "/buyer";
  static const String getHomepageData = "$_buyer/homepage";

  //? settings
  static const String updateSettings = "$_buyer/settings/update";
  static const String getSettings = "$_buyer/settings";

  //? properties
  static const String properties = "/properties";
  static String getPropertyDetails(int id) => "$_buyer/properties/$id";

  //? filter
  static const String filterData = "$_buyer/filter-options";
  static const String searchProperties = "$_buyer/search";

  //? favorites
  static const String toggleFavorite = "/favorites/toggle";
  static const String getSavedProperties = "/favorites";
}
