import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/constant/sizes_constant.dart';
import 'package:life_berg/controller/auth_controller/signup_controller.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/utils/toast_utils.dart';
import 'package:life_berg/view/screens/auth/login.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';
import 'package:life_berg/view/widget/social_login.dart';

// ignore: must_be_immutable
class Signup extends StatelessWidget {
  SignupController controller = Get.put(SignupController());

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
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: kTertiaryColor,
          elevation:  1,
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Image.asset(
                  Assets.imagesArrowBack,
                  height: 24,
                  color: kSecondaryColor,
                ),
              ),
            ],
          ),
          title: MyText(
            text: 'Back',
            size: 16,
            weight: FontWeight.w500,
            color: kSecondaryColor,
          ),
        ),
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
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Image.asset(
                        Assets.imagesLogo,
                        height: 83.34,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MyTextField(
                        hint: 'Full Name',
                        fillColor: kInputFillColor,
                        controller: controller.nameCon,
                        textInputAction: TextInputAction.next,
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
                        controller: controller.passCon,
                        haveObSecureIcon: true,
                        fillColor: kInputFillColor,
                        textCapitalization: TextCapitalization.none,
                        textInputAction: TextInputAction.next,
                      ),
                      MyTextField(
                        haveObSecureIcon: true,
                        isObSecure: true,
                        controller: controller.repeatPassCon,
                        hint: 'Repeat password',
                        fillColor: kInputFillColor,
                        textCapitalization: TextCapitalization.none,
                        textInputAction: TextInputAction.done,
                      ),
                      MyText(
                        paddingTop: 5,
                        text:
                            'By creating an account, you agree to our Terms and Conditions',
                        size: 11,
                        color: kTextColor,
                        weight: FontWeight.w400,
                        paddingBottom: 25,
                      ),
                      Obx(() {
                        return MyButton(
                          isDisable: controller.isDisable.value,
                          text: 'Sign Up',
                          height: 56,
                          radius: 16,
                          onTap: () {
                            if(controller.nameCon.text.toString().isNotEmpty && controller.emailCon.text.toString().isNotEmpty
                            && controller.passCon.text.toString().isNotEmpty && controller.repeatPassCon.text.toString().isNotEmpty){
                              if(controller.passCon.text.toString() == controller.repeatPassCon.text.toString()){
                                controller.signUp();
                              }else{
                                ToastUtils.showToast("Both Passwords are not same.");
                              }
                            }else{
                              ToastUtils.showToast("Please enter all fields.");
                            }
                          },
                        );
                      }),
                      MyText(
                        paddingTop: 25,
                        text: 'Or sign up using',
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
                horizontal: 15,
                vertical: Platform.isIOS ? IOS_BOTTOM_MARGIN : 12,
              ),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  MyText(
                    text: 'If you already have an account, ',
                    size: 15,
                    color: kTertiaryColor,
                  ),
                  MyText(
                    onTap: () => Get.offAll(() => Login()),
                    text: 'sign in now',
                    size: 15,
                    color: kTertiaryColor,
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
