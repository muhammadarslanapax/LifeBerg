import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/main.dart';
import 'package:life_berg/view/widget/common_image_view.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

class OurStory extends StatelessWidget {
  const OurStory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkGreyColor2,
      appBar: simpleAppBar(
        title: 'Our Story',
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(15),
        physics: BouncingScrollPhysics(),
        children: [
          MyText(
            text: 'The Clunky Spreadsheet',
            size: 18,
            color: kSecondaryColor,
            weight: FontWeight.w500,
            paddingBottom: 10,
          ),
          MyText(
            text:
                'Even before we had entered into the full swing of a new academic year, echoes energetically bounced off our campus walls. The consensus was that the year ahead would be a 40-week marathon and that we would all be at risk of burnout.I am hopelessly fascinated by the wonders of medicine and see it as an absolute privilege to maybe one day, apply what we have learnt to make a difference in patients\' lives. However, amongst the commotion of the year, would other activities that I uphold with great importance subtly dwindle and fall by the wayside?\n\nOn a personal level, my Christian faith serves as the cornerstone of my life. It underpins my values and beliefs, plays a central role in how I go about my day and keeps me grounded. I am perpetually reminded that our stint on Earth can end anytime and that all possessions and pursuits are equally fragile and will pass with the seasons. Hence, for me, setting time aside to pray, read the bible and attend various church activities throughout the week has always been an uncompromisable priority.\n\nLike most medical students, my other goals for the year included adequate exercise, nutrition, quality sleep and time for family and friends. Then of course there\'s the much-needed time to dive into the wonders of medicine, work, engage in meaningful projects and complete duller life administration tasks\!\n\nOne morning during COVID isolation, I came up with a clunky spreadsheet to keep track of the above goals. It quickly became apparent that I wasn\'t going to achieve every goal every 24-hours, but I found it helpful to oversee trends and evaluate which goals were going well and which needed a bit more attention. Surprisingly, the clunky spreadsheet really helped me to become more mindful of my time; however, after around 3 months, it became a tedious task and I stopped.Next question was, what if there was an app that could automate my spreadsheet? Rummaging through hundreds of apps on the app store with my brother, nothing seemed to tick all of the boxes. Hence begged the question - could we transform the old clunky spreadsheet into an app for myself and those in the same boat?\n\nOur journey to bring LifeBerg into fruition has been a long one - peppered with stops during busy exam periods and long days on hospital and community placements; however, our vision to help medical and non-medical individuals alike have kept us going. Our commitment from the beginning has been to make LifeBerg free and accessible to all and it would be our absolute privilege to support you so that you can, in turn, support those around you. Hanh :) ',
            size: 13,
            color: kSecondaryColor,
            height: 1.85,
            paddingBottom: 18,
          ),
          CommonImageView(
            height: 320,
            imagePath: Assets.imagesInHospital1,
            radius: 15,
          ),
          SizedBox(
            height: 15,
          ),
          CommonImageView(
            height: 302,
            imagePath: Assets.imagesInHospital2,
            radius: 9.73,
          ),
        ],
      ),
    );
  }
}
