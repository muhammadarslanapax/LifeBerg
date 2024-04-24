import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/controller/auth_controller/forgot_pass_controller.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/screens/auth/forgot_pass/verification_code.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

// ignore: must_be_immutable
class ForgotPass extends StatelessWidget {
  ForgotPassController controller = Get.put(ForgotPassController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      // appBar: simpleAppBar(
      //   title: 'Back',
      // ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Image.asset(
                Assets.imagesForgotPassNew1,
                height: 285,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 20,
            ),
            child: Column(
              children: [
                MyText(
                  text: 'Forgot Your Password?',
                  size: 24,
                  weight: FontWeight.w500,
                  align: TextAlign.center,
                ),
                MyText(
                  paddingTop: 6,
                  text:
                      'Type your email address and we will send the verification code.',
                  size: 16,
                  align: TextAlign.center,
                  height: 1.5,
                  paddingBottom: 20,
                ),
                MyTextField(
                  fillColor: kInputFillColor,
                  hint: 'Email Address',
                  onChanged: (value) => controller.getEmail(value),
                  marginBottom: 25,
                ),
                Obx(() {
                  return MyButton(
                    radius: 16.0,
                    isDisable: controller.isDisable.value,
                    text: 'Reset',
                    onTap: () => Get.to(() => VerificationCode()),
                  );
                }),
              ],
            ),
          ),
          Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }
}
