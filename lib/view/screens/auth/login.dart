import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/constant/sizes_constant.dart';
import 'package:life_berg/controller/auth_controller/login_controler.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/screens/auth/signup.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';
import 'package:life_berg/view/widget/social_login.dart';

import 'forgot_pass/forgot_pass.dart';

// ignore: must_be_immutable
class Login extends StatelessWidget {
  LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: [
        GestureType.onTap,
        GestureType.onPanUpdateDownDirection,
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kPrimaryColor,
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
                        textInputType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        controller: controller.emailCon,
                        textCapitalization: TextCapitalization.none,
                        fillColor: kInputFillColor,
                      ),
                      MyTextField(
                        isObSecure: true,
                        hint: 'Password',
                        fillColor: kInputFillColor,
                        textCapitalization: TextCapitalization.none,
                        textInputAction: TextInputAction.done,
                        controller: controller.passCon,
                      ),
                      MyText(
                        onTap: () => Get.to(() => ForgotPass()),
                        paddingTop: 4,
                        align: TextAlign.end,
                        text: 'Forgot Password?',
                        size: 14,
                        color: kSecondaryTextColor,
                        paddingBottom: 25,
                      ),
                      Obx(() {
                        return MyButton(
                            isDisable: controller.isDisable.value,
                            text: 'Sign In',
                            height: 56,
                            radius: 16,
                            onTap: () => {
                                  if (controller.emailCon.text
                                          .toString()
                                          .isNotEmpty &&
                                      controller.passCon.text
                                          .toString()
                                          .isNotEmpty)
                                    {controller.loginUser()}
                                  else
                                    {
                                      Fluttertoast.showToast(
                                          msg: "Please enter all fields.")
                                    }
                                });
                      }),
                      MyText(
                        paddingTop: 25,
                        text: 'Or sign in using',
                        size: 15,
                        weight: FontWeight.w400,
                        color: kTextColor,
                        paddingBottom: 8,
                      ),
                      SocialLogin(
                        onGoogle: () {
                          controller.signInWithGoogle();
                        },
                        onFacebook: () {
                          controller.signInWithFacebook();
                        },
                        onApple: () {
                          controller.signInWithApple();
                        },
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
                    text: 'If you don’t have an account, ',
                    size: 15,
                    color: kTertiaryColor,
                  ),
                  MyText(
                    onTap: () => Get.to(() => Signup()),
                    text: 'sign up for free',
                    color: kTertiaryColor,
                    size: 15,
                    textDecorationColor: kTertiaryColor,
                    decoration: TextDecoration.underline,
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
