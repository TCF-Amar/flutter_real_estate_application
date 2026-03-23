class ApiEndpoints {
  // ── Base paths ───────────────────────────────────────────────────────────
  static const String _base = "/api";
  static const String _auth = "$_base/auth";
  static const String _buyer = "$_base/buyer";
  static const String _onboarding = "$_base/onboarding";
  static const String _favorites = "$_base/favorites";
  static const String _profile = "$_base/profile";

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
  static String visitBook = "$_base/visits";
  static String getVisitDetails(int id) => "$_base/visits/$id";
  static String cancelVisit(int id) => "$_base/visits/$id/cancel";
  static String propertyInquiry(int id) => "$_buyer/properties/$id/enquiry";

  // Booking

  // static const String getBookingsP = "$_base/bookings";
  static const String getBookedProperties = "$_base/bookings";
  static String getBookingDetails(int id) => "$_base/bookings/$id";

  // ── Search & Filter ──────────────────────────────────────────────────────
  static const String filterData = "$_buyer/filter-options";
  static const String searchProperties = "$_buyer/search";

  // ── Agents ───────────────────────────────────────────────────────────────
  static const String agents = "$_buyer/agents";
  static String getAgentDetails(int id) => "$_buyer/agents/$id";
  static String agentReviews(int id) => "$_buyer/agents/$id/reviews";

  // ── Settings ─────────────────────────────────────────────────────────────
  static const String getSettings = "$_buyer/settings";
  static const String updateSettings = "$_buyer/settings/update";

  // ── Favorites ────────────────────────────────────────────────────────────
  static const String toggleFavoriteProperty = "$_favorites/toggle";
  static const String getSavedProperties = _favorites;
  static const String getSavedAgents = "$_favorites/agents";

  static String sendAgentEnquiry(int id) => "$_buyer/agents/$id/enquiry";

  // ── Profile ──────────────────────────────────────────────────────────────
  static const String uploadAvatar = "$_buyer/upload-avatar";
  static const String updateBasicInfo = "$_profile/basic";

  // ── Notifications ─────────────────────────────────────────────────────────
  static const String deleteAccount = "$_profile/delete-account";

  static const String requestToUpdate = "$_buyer/request-change-otp";
  static const String verifyChangeOtp = "$_buyer/verify-change-otp";
  static const String changePassword = "$_profile/password";

  static const String getVisits = "$_base/visits";

  static const String sendMaintenanceRequest = "$_base/maintenance/requests";
  static String getMaintenanceDetails(int id) =>
      "$_base/maintenance/requests/$id";
}
