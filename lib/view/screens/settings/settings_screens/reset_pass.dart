import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_dialog.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

// ignore: must_be_immutable
class ResetPass extends StatelessWidget {
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
          ),
          MyTextField(
            hint: 'New Password',
            isObSecure: true,
            haveObSecureIcon: true,
          ),
          MyTextField(
            hint: 'Confirm Password',
            isObSecure: true,
            haveObSecureIcon: true,
            marginBottom: 25,
          ),
          MyButton(
            isDisable: false,
            text: 'Reset Password',
            onTap: () {
              showDialog(
                context: context,
                builder: (_) {
                  return MyDialog(
                    height: 184,
                    heading: 'Reset Password',
                    content: 'Your current password has been reset.',
                    onOkay: () => Get.back(),
                  );
                },
              );
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
