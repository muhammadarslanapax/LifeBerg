import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/controller/auth_controller/forgot_pass_controller.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';

// ignore: must_be_immutable
class ForgotPass extends StatelessWidget {
  ForgotPassController controller = Get.put(ForgotPassController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Column(
        children: [
          SizedBox(
            height: 40,
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
                      'Please type your email address below and we will send you the verification code.',
                  size: 16,
                  align: TextAlign.center,
                  height: 1.5,
                  paddingBottom: 20,
                ),
                MyTextField(
                  hint: 'Email Address',
                  onChanged: (value) => controller.getEmail(value),
                  marginBottom: 25,
                  textInputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  controller: controller.emailCon,
                  textCapitalization: TextCapitalization.none,
                  fillColor: kSecondaryColor,
                ),
                Obx(() {
                  return MyButton(
                    height: 56,
                    radius: 16,
                    isDisable: controller.isDisable.value,
                    text: 'Reset',
                    onTap: () => controller.sendVerificationCode(),
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
