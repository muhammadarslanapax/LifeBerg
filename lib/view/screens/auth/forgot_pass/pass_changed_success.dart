import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/screens/auth/login.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

// ignore: must_be_immutable
class PassChangedSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      body: Column(
        children: [
          Spacer(
            flex: 3,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Image.asset(
              Assets.imagesForgotPassNew4,
              height: 185,
            ),
          ),
          SizedBox(height: 48,),
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
                  paddingTop: 8,
                  text:
                      'Congratulations! Your new password has been created successfully. Sign In right away.',
                  size: 16,
                  align: TextAlign.center,
                  height: 1.5,
                  paddingBottom: 25,
                ),
                MyButton(
                  radius: 16.0,
                  height: 56,
                  isDisable: false,
                  text: 'Login',
                  onTap: () => Get.offAll(() => Login()),
                ),
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
