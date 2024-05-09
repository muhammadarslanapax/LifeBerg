import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/controller/auth_controller/forgot_pass_controller.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/my_border_button.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:pinput/pinput.dart';

// ignore: must_be_immutable
class VerificationCode extends StatelessWidget {
  ForgotPassController controller = Get.find<ForgotPassController>();

  final defaultPinTheme = PinTheme(
    height: 47,
    width: 80,
    margin: EdgeInsets.symmetric(horizontal: 5.0),
    textStyle: TextStyle(
      fontSize: 16,
      color: kBlackColor.withOpacity(0.36),
    ),
    decoration: BoxDecoration(
      color: kSecondaryColor,
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
      backgroundColor: kPrimaryColor,
      // appBar: simpleAppBar(
      //   title: 'Back',
      // ),
      body: Column(
        children: [
          SizedBox(
            height: 40,
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
                      'Please enter the code that we have sent to your email ${controller.emailCon.text.toString()}',
                  size: 16,
                  align: TextAlign.center,
                  height: 1.5,
                  paddingBottom: 20,
                ),
                Pinput(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  length: 4,
                  showCursor: true,
                  controller: controller.otpCon,
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
                    height: 56,
                    radius: 16,
                    isDisable: controller.isVerifyDisable.value,
                    text: 'Verify',
                    onTap: () => controller.verifyEmailCode(),
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                MyBorderButton(
                  height: 56,
                  radius: 16,
                  borderColor: kTertiaryColor,
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
