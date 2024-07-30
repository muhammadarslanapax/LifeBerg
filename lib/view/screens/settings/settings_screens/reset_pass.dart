import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/utils/toast_utils.dart';
import 'package:life_berg/view/screens/settings/settings_screens/settings_controller.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_dialog.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

// ignore: must_be_immutable
class ResetPass extends StatelessWidget {
  final SettingsController settingsController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCoolGreyColor3,
      appBar: simpleAppBar(
        title: 'Reset Password',
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        physics: BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Image.asset(
              Assets.imagesNewPassBg,
              height: 273,
            ),
          ),
          MyText(
            text: 'Reset Password',
            size: 24,
            weight: FontWeight.w500,
            align: TextAlign.center,
          ),
          MyText(
            paddingTop: 6,
            text: 'Create a new password to reset your current password',
            size: 16,
            align: TextAlign.center,
            height: 1.5,
            paddingBottom: 20,
          ),
          MyTextField(
            hint: 'Current Password',
            isObSecure: true,
            haveObSecureIcon: true,
            controller: settingsController.currentPassController,
          ),
          MyTextField(
            hint: 'New Password',
            isObSecure: true,
            haveObSecureIcon: true,
            controller: settingsController.mewPassController,
          ),
          MyTextField(
            hint: 'Confirm Password',
            isObSecure: true,
            haveObSecureIcon: true,
            marginBottom: 25,
            controller: settingsController.confirmPassController,
          ),
          MyButton(
            isDisable: false,
            text: 'Reset Password',
            onTap: () {
              String currentPassword =
                  settingsController.currentPassController.text;
              String newPassword = settingsController.mewPassController.text;
              String confirmPassword =
                  settingsController.confirmPassController.text;
              if (currentPassword.isNotEmpty &&
                  newPassword.isNotEmpty &&
                  confirmPassword.isNotEmpty) {
                if (newPassword == confirmPassword) {
                  settingsController.resetPassword(
                      context, currentPassword, newPassword);
                } else {
                  ToastUtils.showToast("Passwords did not match.",
                      color: kRedColor);
                }
              } else {
                ToastUtils.showToast("Please fill out all the fields.",
                    color: kRedColor);
              }
            },
          ),
          Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }
}
