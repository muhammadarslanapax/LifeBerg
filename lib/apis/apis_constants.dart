class ApiConstants {
  static String BASE_URL = "http://life-berg.eu-4.evennode.com";
  static String BASE_IMAGE_URL =
      "http://life-berg.eu-4.evennode.com/uploads/images/";
  static String LOGIN = "$BASE_URL/api/user/user-login";
  static String SIGNUP = "$BASE_URL/api/user/signup";
  static String SOCIAL_LOG_IN = "$BASE_URL/api/user/social-signup";
  static String FORGOT_PASS_STEP_ONE = "${BASE_URL}/api/user/forget-password";
  static String FORGOT_PASS_STEP_TWO =
      "${BASE_URL}/api/user/verify-password-otp";
  static String FORGOT_PASS_STEP_THREE =
      "${BASE_URL}/api/user/restore-password";
  static String UPDATE_USER = "${BASE_URL}/api/user/profile/update";
  static String SUBMIT_MOOD = "${BASE_URL}/api/user/profile/submit-mood";
  static String ADD_GOAL = "${BASE_URL}/api/user/profile/create-goal";
  static String UPDATE_GOAL = "${BASE_URL}/api/user/profile/update-goal";
  static String GOAL_LIST = "${BASE_URL}/api/user/profile/user-goals";
  static String DELETE_GOAL = "${BASE_URL}/api/user/profile/delete-goal";
  static String DELETE_JOURNAL = "${BASE_URL}/api/user/profile/delete-journal";
  static String GOAL_COMMENT = "${BASE_URL}/api/user/profile/delete-goal";
  static String DELETE_PROFILE_PIC =
      "${BASE_URL}/api/user/profile/delete-profile-picture";
  static String ADD_JOURNAL = "${BASE_URL}/api/user/profile/create-journal";
  static String UPDATE_JOURNAL = "${BASE_URL}/api/user/profile/update-journal";
  static String JOURNAL_LIST = "${BASE_URL}/api/user/profile/journal-list";
  static String SUBMIT_GOAL = "${BASE_URL}/api/user/profile/submit-report";
  static String GET_ALL_GOALS_REPORT =
      "${BASE_URL}/api/user/profile/goals-report";
  static String GET_ALL_MOOD_HISTORY =
      "${BASE_URL}/api/user/profile/mood-history";
  static String GET_ACTION_PLANS =
      "${BASE_URL}/api/user/profile/user-action-plan";
  static String CREATE_ACTION_PLAN =
      "${BASE_URL}/api/user/profile/create-action-plan";
  static String UPDATE_ACTION_PLAN =
      "${BASE_URL}/api/user/profile/update-action-plan";
  static String DELETE_ACTION_PLAN =
      "${BASE_URL}/api/user/profile/delete-action-plan";
  static String GET_GOAL_REPORT =
      "${BASE_URL}/api/user/profile/goal-report";
  static String GET_CURRENT_USER_DETAIL =
      "${BASE_URL}/api/user/profile/current-user";
  static String RESET_PASSWORD =
      "${BASE_URL}/api/user/profile/reset-password";
  static String DATE_GOAL_REPORT =
      "${BASE_URL}/api//user/profile/mood-goal";
  static String TOP_STREAK =
      "${BASE_URL}/api/user/profile/top-streak";
}