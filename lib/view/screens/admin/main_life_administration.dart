import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/screens/admin/big_picture/big_picture.dart';
import 'package:life_berg/view/screens/admin/count_down/count_down.dart';
import 'package:life_berg/view/screens/admin/filling_cabinet/filling_cabinet.dart';
import 'package:life_berg/view/screens/admin/second_brain/second_brain.dart';
import 'package:life_berg/view/screens/admin/wellbeing_action_plan/wellbeing_action_plan.dart';
import 'package:life_berg/view/widget/admin_cards.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

class MainLifeAdministration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      appBar: simpleAppBar(
        title: 'Life Administration',
        haveLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: AdminCards(
                    icon: Assets.imagesBrain,
                    title: 'Second Brain',
                    iconSize: 32.0,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SecondBrain(),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: AdminCards(
                    icon: Assets.imagesSend,
                    title: 'Big Picture',
                    iconSize: 24.0,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BigPicture(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: AdminCards(
                    icon: Assets.imagesFillingCabinet,
                    title: 'Filling Cabinet',
                    iconSize: 24.0,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FillingCabinet(),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: AdminCards(
                    icon: Assets.imagesTimer,
                    title: 'Countdown',
                    iconSize: 24.0,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CountDown(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            AdminCards(
              icon: Assets.imagesActionPlan,
              title: 'Wellbeing Action Plan',
              iconSize: 28.0,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WellbeingActionPlan(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
