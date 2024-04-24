import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/my_border_button.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

class Legal extends StatelessWidget {
  const Legal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCoolGreyColor3,
      appBar: simpleAppBar(
        title: 'Legal',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 17,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MainHeading(
              text: 'Terms of service',
              paddingBottom: 4,
            ),
            MyBorderButton(
              text: 'Find out more',
              onTap: () {},
              height: 50,
            ),
            MainHeading(
              text: 'Privacy policy',
              paddingBottom: 4,
              paddingTop: 24,
            ),
            MyBorderButton(
              text: 'Find out more',
              onTap: () {},
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
