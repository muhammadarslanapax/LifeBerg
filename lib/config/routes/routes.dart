import 'package:get/get.dart';
import 'package:life_berg/view/screens/auth/forgot_pass/forgot_pass.dart';
import 'package:life_berg/view/screens/auth/login.dart';
import 'package:life_berg/view/screens/auth/signup.dart';
import 'package:life_berg/view/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:life_berg/view/screens/launch/on_boarding.dart';
import 'package:life_berg/view/screens/launch/splash_screen.dart';

class AppRoutes {
  static final List<GetPage> pages = [
    GetPage(
      name: AppLinks.splash_screen,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: AppLinks.on_boarding,
      page: () => OnBoarding(),
    ),
    GetPage(
      name: AppLinks.login,
      page: () => Login(),
    ),
    GetPage(
      name: AppLinks.signup,
      page: () => Signup(),
    ),
    // GetPage(
    //   name: AppLinks.forgot_pass,
    //   page: () => ForgotPass(),
    // ),
    GetPage(
      name: AppLinks.bottom_nav_bar,
      page: () => BottomNavBar(),
    ),
  ];
}

class AppLinks {
  static const splash_screen = '/splash_screen';
  static const on_boarding = '/on_boarding';
  static const login = '/login';
  static const signup = '/signup';
  static const forgot_pass = '/forgot_pass';
  static const bottom_nav_bar = '/bottom_nav_bar';
}
