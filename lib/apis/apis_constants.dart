class ApiConstants {

  static String BASE_URL = "http://life-berg.eu-4.evennode.com";
  static String LOGIN = "$BASE_URL/api/user/user-login";
  static String SIGNUP = "$BASE_URL/api/user/signup";
  static String SOCIAL_LOG_IN = "$BASE_URL/api/user/social-signup";
  static String FORGOT_PASS_STEP_ONE = "${BASE_URL}/api/user/forget-password";
  static String FORGOT_PASS_STEP_TWO = "${BASE_URL}/api/user/verify-password-otp";
  static String FORGOT_PASS_STEP_THREE = "${BASE_URL}/api/user/restore-password";
  static String UPDATE_USER = "${BASE_URL}/api/user/profile/update";
}