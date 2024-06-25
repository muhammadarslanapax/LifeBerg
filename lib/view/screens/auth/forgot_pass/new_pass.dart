import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/controller/auth_controller/forgot_pass_controller.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';

// ignore: must_be_immutable
class NewPass extends StatelessWidget {
  ForgotPassController controller = Get.find<ForgotPassController>();

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
                  fillColor: kSecondaryColor,
                  hint: 'Password',
                  isObSecure: true,
                  haveObSecureIcon: true,
                  controller: controller.passCon,
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.next,
                ),
                MyTextField(
                  fillColor: kSecondaryColor,
                  hint: 'Confirm Password',
                  isObSecure: true,
                  controller: controller.confirmCon,
                  haveObSecureIcon: true,
                  onChanged: (value) => controller.getConfirmPass(value),
                  marginBottom: 25,
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.done,
                ),
                Obx(() {
                  return MyButton(
                    radius: 16.0,
                    height: 56,
                    isDisable: controller.isNewPassDisable.value,
                    text: 'Create Password',
                    onTap: () => controller.resetPassword(),
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
