import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/constant/sizes_constant.dart';
import 'package:life_berg/controller/auth_controller/login_controler.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/model/authentocation_models/login_model.dart';
import 'package:life_berg/view/screens/auth/complete_profile/complete_profile.dart';
import 'package:life_berg/view/screens/auth/signup.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';
import 'package:life_berg/view/widget/social_login.dart';

import '../../../apis/http_manager.dart';
import '../../../shareprefrences/user_sharedprefrence.dart';
import 'forgot_pass/forgot_pass.dart';

// ignore: must_be_immutable
class Login extends StatelessWidget {
  LoginController controller = Get.put(LoginController());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  HttpManager httpManager = HttpManager();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  _loginUpUser() async {
    SmartDialog.showLoading(msg: "Please wait..");
    String? token = await FirebaseMessaging.instance.getToken();
    httpManager
        .loginUp(_emailController.text.toString(),
            _passwordController.text.toString(), token ?? "")
        .then((value) {
      SmartDialog.dismiss();
      if (value.error == null) {
        LoginModel loginModel = value.snapshot;
        if (loginModel.success == true) {
          Fluttertoast.showToast(msg: loginModel.message ?? "");

          SharedPreferencesForUser.getInstance().then((prefs) {
            prefs.setLoggedIn(true);
            prefs.setToken(loginModel.token ?? "");
            prefs.setFirstName(loginModel.data!.firstName ?? "");
            prefs.setLastName(loginModel.data!.lastName ?? "");
            prefs.setEmail(loginModel.data!.email ?? "");
            prefs.setUserID(loginModel.data!.sId ?? "");

              Get.to(() => CompleteProfile());
          });
        } else {
          SmartDialog.dismiss();
          Fluttertoast.showToast(msg: loginModel.message ?? "");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: [
        GestureType.onTap,
        GestureType.onPanUpdateDownDirection,
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollBehavior(),
                child: GlowingOverscrollIndicator(
                  axisDirection: AxisDirection.down,
                  color: kPrimaryColor,
                  child: ListView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 20,
                    ),
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Image.asset(
                        Assets.imagesLogo,
                        height: 83.34,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MyTextField(
                        onChanged: (value) => controller.getEmail(value),
                        hint: 'Email Address',
                        controller: _emailController,
                      ),
                      MyTextField(
                        isObSecure: true,
                        hint: 'Password',
                        controller: _passwordController,
                      ),
                      MyText(
                        onTap: () => Get.to(() => ForgotPass()),
                        paddingTop: 4,
                        align: TextAlign.end,
                        text: 'Forgot Password?',
                        size: 16,
                        paddingBottom: 25,
                      ),
                      Obx(() {
                        return MyButton(
                            isDisable: controller.isDisable.value,
                            text: 'Sign In',
                            onTap: () => {
                                  if (_emailController.text
                                          .toString()
                                          .isNotEmpty &&
                                      _passwordController.text
                                          .toString()
                                          .isNotEmpty)
                                    {_loginUpUser()}
                                  else
                                    {
                                      Fluttertoast.showToast(
                                          msg: "Please enter all fields.")
                                    }
                                } // Get.to(() => CompleteProfile()),
                            );
                      }),
                      SocialLogin(
                        onGoogle: () {},
                        onFacebook: () {},
                        onApple: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: Platform.isIOS ? IOS_BOTTOM_MARGIN : 12,
              ),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  MyText(
                    text: 'Don’t have an account?',
                    size: 14,
                  ),
                  MyText(
                    onTap: () => Get.to(() => Signup()),
                    text: ' Sign up for free.',
                    color: kTertiaryColor,
                    size: 14,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
