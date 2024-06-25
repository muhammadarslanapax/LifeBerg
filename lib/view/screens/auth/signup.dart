import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/constant/sizes_constant.dart';
import 'package:life_berg/constant/strings.dart';
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
    return Scaffold(
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
          text: back,
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
                      hint: fullName,
                      fillColor: kInputFillColor,
                      controller: controller.nameCon,
                      textInputAction: TextInputAction.next,
                    ),
                    MyTextField(
                      onChanged: (value) => controller.getEmail(value),
                      hint: emailAddress,
                      textInputType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      controller: controller.emailCon,
                      textCapitalization: TextCapitalization.none,
                      fillColor: kInputFillColor,
                    ),
                    MyTextField(
                      isObSecure: true,
                      hint: password,
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
                      hint: repeatPassword,
                      fillColor: kInputFillColor,
                      textCapitalization: TextCapitalization.none,
                      textInputAction: TextInputAction.done,
                    ),
                    MyText(
                      paddingTop: 5,
                      text:
                      signUpTerms,
                      size: 11,
                      color: kTextColor,
                      weight: FontWeight.w400,
                      paddingBottom: 25,
                    ),
                    Obx(() {
                      return MyButton(
                        isDisable: controller.isDisable.value,
                        text: signUp,
                        height: 56,
                        radius: 16,
                        onTap: () {
                          if(controller.nameCon.text.toString().isNotEmpty && controller.emailCon.text.toString().isNotEmpty
                          && controller.passCon.text.toString().isNotEmpty && controller.repeatPassCon.text.toString().isNotEmpty){
                            if(controller.passCon.text.toString() == controller.repeatPassCon.text.toString()){
                              controller.signUp();
                            }else{
                              ToastUtils.showToast(passwordNotSameError);
                            }
                          }else{
                            ToastUtils.showToast(enterAllFields);
                          }
                        },
                      );
                    }),
                    MyText(
                      paddingTop: 25,
                      text: signUpUsing,
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
                        controller.signInWithFacebook(context);
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
                  text: ifAlreadyHaveAcc,
                  size: 15,
                  color: kTertiaryColor,
                ),
                MyText(
                  onTap: () => Get.offAll(() => Login()),
                  text: signInNow,
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
    );
  }
}
