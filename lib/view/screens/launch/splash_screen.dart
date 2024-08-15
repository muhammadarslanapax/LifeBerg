import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/utils/pref_utils.dart';
import 'package:life_berg/view/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:life_berg/view/screens/launch/on_boarding.dart';

import '../auth/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    splashScreenHandler();
  }

  void splashScreenHandler() {
    Future.delayed(
      Duration(seconds: 2),
      () => Get.offAll(() => !PrefUtils().getIsShowIntro ?
          PrefUtils().loggedIn ?
              BottomNavBar(
                key: bottomNavBarKey,
              ) :
      Login() : OnBoarding()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSplashBgColor,
      body: Center(
        child: Image.asset(
          Assets.imagesLogo,
          height: 121,
        ),
      ),
    );
  }
}
