import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/screens/settings/settings_screens/reset_pass.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/my_border_button.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: [
        GestureType.onTap,
        GestureType.onPanUpdateDownDirection,
      ],
      child: Scaffold(
        backgroundColor: kCoolGreyColor3,
        appBar: simpleAppBar(
          title: 'Account Settings',
        ),
        body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(15),
          physics: BouncingScrollPhysics(),
          children: [
            MainHeading(
              text: 'Personal information',
              paddingBottom: 8,
            ),
            MyTextField(
              hint: 'Name',
            ),
            MyTextField(
              hint: 'Email Address',
            ),
            MyTextField(
              hint: 'City',
            ),
            MyTextField(
              hint: 'Primary Vocation',
            ),
            MyTextField(
              hint: 'Date Of Birth (MM/DD/YY)',
              marginBottom: 16,
            ),
            MainHeading(
              text: 'Subscriptions',
              paddingBottom: 8,
            ),
            MyBorderButton(
              text: 'Free Account',
              onTap: () {},
              height: 50.0,
            ),
            MainHeading(
              text: 'Reset password',
              paddingTop: 30,
              paddingBottom: 8,
            ),
            MyBorderButton(
              text: 'Reset Password',
              onTap: () => Get.to(() => ResetPass()),
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
