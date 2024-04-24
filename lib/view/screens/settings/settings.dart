import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:life_berg/view/screens/settings/historical_reporting_goals.dart';
import 'package:life_berg/view/screens/settings/legal.dart';
import 'package:life_berg/view/screens/settings/settings_screens/about_us.dart';
import 'package:life_berg/view/screens/settings/settings_screens/account_settings.dart';
import 'package:life_berg/view/screens/settings/settings_screens/contact_us.dart';
import 'package:life_berg/view/screens/settings/settings_screens/notifications.dart';
import 'package:life_berg/view/screens/settings/settings_screens/points/points.dart';
import 'package:life_berg/view/screens/settings/settings_screens/subscription.dart';
import 'package:life_berg/view/widget/my_dialog.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/settings_tile.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCoolGreyColor3,
      appBar: simpleAppBar(
        centerTitle: true,
        onBackTap: () => Get.offAll(() => BottomNavBar()),
        title: 'Settings & Controls',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              children: [
                SettingsTiles(
                  onTap: () => Get.to(() => AboutUs()),
                  title: 'About Us',
                  icon: Assets.imagesAboutUs,
                ),
                SettingsTiles(
                  onTap: () => Get.to(() => AccountSettings()),
                  title: 'Account Settings',
                  icon: Assets.imagesSettings,
                ),
                SettingsTiles(
                  onTap: () => Get.to(() => Notifications()),
                  title: 'Notifications',
                  icon: Assets.imagesNotifications,
                ),
                SettingsTiles(
                  onTap: () => Get.to(() => HistoricalReportingGoals()),
                  title: 'Historical Reporting & Goals',
                  icon: Assets.imagesClarityHistoryLine,
                ),

                // SettingsTiles(
                //   onTap: () => Get.to(() => Subscription()),
                //   title: 'Subscription',
                //   icon: Assets.imagesSubscription,
                // ),
                // SettingsTiles(
                //   onTap: () => Get.to(() => Points()),
                //   title: 'Points',
                //   icon: Assets.imagesPoints,
                // ),
                SettingsTiles(
                  onTap: () => Get.to(() => ContactUs()),
                  title: 'Contact Us',
                  icon: Assets.imagesContactUs,
                ),
                SettingsTiles(
                  onTap: () => Get.to(() => Legal()),
                  title: 'Legal',
                  icon: Assets.imagesLegal,
                ),
                SizedBox(
                  height: 56,
                ),
                SettingsTiles(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return MyDialog(
                          height: 206,
                          heading: 'Log Out',
                          content:
                              'Are you sure? Your current account will be logged out.',
                          haveCustomActionButtons: true,
                          customAction: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              MyText(
                                onTap: () {},
                                align: TextAlign.end,
                                text: 'Log Out',
                                size: 14,
                                weight: FontWeight.w500,
                                color: kRedColor,
                                paddingBottom: 15,
                                paddingRight: 30,
                              ),
                              MyText(
                                onTap: () => Get.back(),
                                align: TextAlign.end,
                                text: 'No',
                                size: 14,
                                weight: FontWeight.w500,
                                color: kTertiaryColor,
                                paddingBottom: 15,
                                paddingRight: 15,
                              ),
                            ],
                          ),
                          onOkay: () {},
                        );
                      },
                    );
                  },
                  title: 'Log Out',
                  icon: Assets.imagesLogout,
                  haveNextIcon: false,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Image.asset(Assets.imagesLogo,height: 60,),
          ),
        ],
      ),
    );
  }
}
