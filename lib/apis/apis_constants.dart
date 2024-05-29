class ApiConstants {

  static String BASE_URL = "http://life-berg.eu-4.evennode.com";
  static String BASE_IMAGE_URL = "http://life-berg.eu-4.evennode.com/uploads/images/";
  static String LOGIN = "$BASE_URL/api/user/user-login";
  static String SIGNUP = "$BASE_URL/api/user/signup";
  static String SOCIAL_LOG_IN = "$BASE_URL/api/user/social-signup";
  static String FORGOT_PASS_STEP_ONE = "${BASE_URL}/api/user/forget-password";
  static String FORGOT_PASS_STEP_TWO = "${BASE_URL}/api/user/verify-password-otp";
  static String FORGOT_PASS_STEP_THREE = "${BASE_URL}/api/user/restore-password";
  static String UPDATE_USER = "${BASE_URL}/api/user/profile/update";
  static String SUBMIT_MOOD = "${BASE_URL}/api/user/profile/submit-mood";
  static String ADD_GOAL = "${BASE_URL}/api/user/profile/create-goal";
  static String UPDATE_GOAL = "${BASE_URL}/api/user/profile/update-goal";
  static String GOAL_LIST = "${BASE_URL}/api/user/profile/user-goals";
  static String DELETE_GOAL = "${BASE_URL}/api/user/profile/delete-goal";
  static String GOAL_COMMENT = "${BASE_URL}/api/user/profile/delete-goal";
}