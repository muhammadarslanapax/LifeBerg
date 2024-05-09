import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:life_berg/config/routes/routes.dart';
import 'package:life_berg/config/theme/light_theme.dart';
import 'package:life_berg/controller/admin_controller/wellbeing_action_plan_controller.dart';
import 'package:life_berg/controller/auth_controller/complete_profile_controller.dart';
import 'package:life_berg/controller/auth_controller/goal_controller.dart';
import 'package:life_berg/controller/journal_controller/journal_controller.dart';
import 'package:life_berg/controller/personal_development_controller/personal_development_controller.dart';
import 'package:life_berg/shareprefrences/user_sharedprefrence.dart';
import 'package:life_berg/utils/pref_utils.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  Get.put(PersonalDevelopmentController());
  Get.put(WellbeingActionPlanController());
  Get.put(JournalController());
  Platform.isAndroid ?
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDai2j351LxfaC5Y7I_vifhQWGXcmr0Rvc",
          appId:  "1:648558078003:android:c464f7f9a623aa366f1b46",
          messagingSenderId: "648558078003",
          projectId: "lifeberg-dev")) :
  await Firebase.initializeApp();
  PrefUtils().init();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  SharedPreferencesForUser.getInstance();

  runApp(MyApp());
}

//DO NOT REMOVE Unless you find usage.
String dummyImg3 =
    'https://images.unsplash.com/photo-1629747490241-624f07d70e1e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=735&q=80';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: lightTheme,
      builder: FlutterSmartDialog.init(),
      themeMode: ThemeMode.light,
      title: 'LifeBerg',
      initialRoute: AppLinks.splash_screen,
      getPages: AppRoutes.pages,
      defaultTransition: Transition.fadeIn,
    );
  }
}
