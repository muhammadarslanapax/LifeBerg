import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/controller/auth_controller/forgot_pass_controller.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/screens/auth/forgot_pass/new_pass.dart';
import 'package:life_berg/view/widget/my_border_button.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';
import 'package:pinput/pinput.dart';

// ignore: must_be_immutable
class VerificationCode extends StatelessWidget {
  ForgotPassController controller = Get.find<ForgotPassController>();

  final defaultPinTheme = PinTheme(
    height: 47,
    width: 77,
    textStyle: TextStyle(
      fontSize: 16,
      color: kBlackColor.withOpacity(0.36),
    ),
    decoration: BoxDecoration(
      color: kInputFillColor,
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(
        color: kBorderColor,
        width: 1.0,
      ),
    ),
  );

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
            height: 20,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Image.asset(
                Assets.imagesForgotPassNew2,
                height: 312,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              children: [
                MyText(
                  text: 'Verification Code',
                  size: 24,
                  weight: FontWeight.w500,
                  align: TextAlign.center,
                ),
                MyText(
                  paddingTop: 6,
                  text:
                      'Enter code that we have sent to your email example@lifeberg.app',
                  size: 16,
                  align: TextAlign.center,
                  height: 1.5,
                  paddingBottom: 20,
                ),
                Pinput(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  length: 4,
                  defaultPinTheme: defaultPinTheme,
                  onCompleted: (pin) {},
                  onChanged: (value) => controller.getOTP(value),
                  focusedPinTheme: defaultPinTheme,
                  submittedPinTheme: defaultPinTheme,
                  errorPinTheme: defaultPinTheme,
                ),
                SizedBox(
                  height: 25,
                ),
                Obx(() {
                  return MyButton(
                    radius: 16.0,
                    isDisable: controller.isVerifyDisable.value,
                    text: 'Verify',
                    onTap: () => Get.to(() => NewPass()),
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                MyBorderButton(
                  radius: 16.0,
                  text: 'Resend Code',
                  onTap: () {},
                ),
              ],
            ),
          ),
          SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}
