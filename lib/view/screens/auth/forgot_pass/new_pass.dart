import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/controller/auth_controller/forgot_pass_controller.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/screens/auth/forgot_pass/pass_changed_success.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

// ignore: must_be_immutable
class NewPass extends StatelessWidget {
  ForgotPassController controller = Get.find<ForgotPassController>();

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
                Assets.imagesForgotPassNew3,
                height: 273,
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
                  text: 'New Password',
                  size: 24,
                  weight: FontWeight.w500,
                  align: TextAlign.center,
                ),
                MyText(
                  paddingTop: 6,
                  text: 'Create your new password to login',
                  size: 16,
                  align: TextAlign.center,
                  height: 1.5,
                  paddingBottom: 20,
                ),
                MyTextField(
                  fillColor: kInputFillColor,
                  hint: 'Password',
                  isObSecure: true,
                  haveObSecureIcon: true,
                  controller: controller.passCon,
                ),
                MyTextField(
                  fillColor: kInputFillColor,
                  hint: 'Confirm Password',
                  isObSecure: true,
                  haveObSecureIcon: true,
                  onChanged: (value) => controller.getConfirmPass(value),
                  marginBottom: 25,
                ),
                Obx(() {
                  return MyButton(
                    radius: 16.0,
                    isDisable: controller.isNewPassDisable.value,
                    text: 'Create Password',
                    onTap: () => Get.offAll(() => PassChangedSuccess()),
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
