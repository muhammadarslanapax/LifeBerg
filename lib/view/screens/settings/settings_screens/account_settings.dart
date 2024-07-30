import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/screens/settings/settings_screens/reset_pass.dart';
import 'package:life_berg/view/screens/settings/settings_screens/settings_controller.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/my_border_button.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';

import '../../../widget/custom_drop_down.dart';

class AccountSettings extends StatelessWidget {
  AccountSettings({Key? key}) : super(key: key);

  final SettingsController settingsController = Get.put(SettingsController());

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
              controller: settingsController.nameController,
            ),
            MyTextField(
              hint: 'Email Address',
              controller: settingsController.emailController,
              isReadOnly: true,
            ),
            MyTextField(
              hint: 'Country',
              controller: settingsController.countryController,
              isReadOnly: true,
              onTap: () {
                showCountryPicker(
                  context: context,
                  showPhoneCode: true,
                  onSelect: (Country country) {
                    settingsController.countryController.text = country.name;
                    settingsController.updateUser(
                        country: settingsController.countryController.text);
                  },
                );
              },
            ),
            Obx(() {
              return CustomDropDown(
                buttonHeight: 56,
                selectedValue: settingsController.selectedVocation.value,
                hint: 'Select',
                onChanged: (value) {
                  settingsController.selectedVocation.value = value;
                  settingsController.updateUser(
                      primaryVocation:
                          settingsController.selectedVocation.value);
                },
                items: settingsController.vocationList,
              );
            }),
            SizedBox(
              height: 10,
            ),
            MyTextField(
              hint: 'Date Of Birth',
              marginBottom: 16,
              controller: settingsController.dobController,
              isReadOnly: true,
              onTap: () {
                DatePicker.showDatePicker(context, onConfirm: (newDate, list) {
                  settingsController.dobController.text =
                      DateFormat("yyyy/MM/dd").format(newDate);
                  settingsController.updateUser(
                      dob: settingsController.dobController.text);
                });
              },
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
