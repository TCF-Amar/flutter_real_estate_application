class ApiEndpoints {
  // ── Base paths ───────────────────────────────────────────────────────────
  static const String _base = "/api";
  static const String _auth = "$_base/auth";
  static const String _buyer = "$_base/buyer";
  static const String _onboarding = "$_base/onboarding";
  static const String _favorites = "$_base/favorites";

  // ── Auth ─────────────────────────────────────────────────────────────────
  static const String login = "$_auth/login";
  static const String signUp = "$_auth/register/buyer";
  static const String verifyOtp = "$_auth/verify-otp";
  static const String resendOtp = "$_auth/resend-otp";
  static const String currentUser = "$_auth/me";
  static const String refreshToken = "$_auth/refresh";
  static const String logout = "$_auth/logout";
  static const String forgotPassword = "$_auth/forgot-password";
  static const String resetPassword = "$_auth/reset-password";

  // ── Onboarding ───────────────────────────────────────────────────────────
  static const String buyerOnboarding = "$_onboarding/buyer";

  // ── Home ─────────────────────────────────────────────────────────────────
  static const String getHomepageData = "$_buyer/homepage";

  // ── Properties ───────────────────────────────────────────────────────────
  static String getPropertyDetails(int id) => "$_buyer/properties/$id";
  static String similarProperties(int id) => "$_buyer/properties/$id/similar";
  static String propertyReviews(int id) => "$_buyer/properties/$id/reviews";

  // ── Search & Filter ──────────────────────────────────────────────────────
  static const String filterData = "$_buyer/filter-options";
  static const String searchProperties = "$_buyer/search";

  // ── Agents ───────────────────────────────────────────────────────────────
  static const String agents = "$_buyer/agents";
  static String getAgentDetails(int id) => "$_buyer/agents/$id";

  // ── Settings ─────────────────────────────────────────────────────────────
  static const String getSettings = "$_buyer/settings";
  static const String updateSettings = "$_buyer/settings/update";

  // ── Favorites ────────────────────────────────────────────────────────────
  static const String getSavedProperties = _favorites;
  static const String toggleFavorite = "$_favorites/toggle";
}
