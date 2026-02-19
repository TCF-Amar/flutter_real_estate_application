class ApiEndpoints {
  //! Auth endpoints
  static const String _auth = "/auth";

  static const String login = "$_auth/login";
  static const String signUp = "$_auth/register/buyer";
  // static const String registerSeller = "$_auth/register/seller";
  static const String verifyOtp = "$_auth/verify-otp";
  static const String resendOtp = "$_auth/resend-otp";
  static const String currentUser = "$_auth/me";
  static const String refreshToken = "$_auth/refresh";
  static const String logout = "$_auth/logout";
  static const String forgotPassword = "$_auth/forgot-password";
  static const String resetPassword = "$_auth/reset-password";

  //? settings
  static const String updateSettings = "/buyer/settings/update";
  static const String getSettings = "/buyer/settings";
}
