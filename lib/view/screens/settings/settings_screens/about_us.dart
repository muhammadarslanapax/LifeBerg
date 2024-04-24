import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/screens/settings/settings_screens/our_journey.dart';
import 'package:life_berg/view/screens/settings/settings_screens/our_story.dart';
import 'package:life_berg/view/widget/journey_card.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';
import 'package:life_berg/view/widget/story_card.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldColor,
      appBar: simpleAppBar(
        title: 'About Us',
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 25,
        ),
        physics: BouncingScrollPhysics(),
        children: [
          MainHeading(
            text: 'Our Journey',
            paddingBottom: 10,
          ),
          JourneyCard(
            icon: Assets.imagesSpiral,
            bgColor: kLightGreenColor,
            haveBottomIcon: false,
            content:
                'It all began with a pain point - the challenges of juggling medical school with church activities, work, time for others, life admin tasks, projects, exercise and self care.\n\nThere was no app that ticked all the boxes...and so the journey began.',
          ),
          MyText(
            text: 'Explore the full timeline',
            size: 14,
            color: kTertiaryColor,
            align: TextAlign.end,
            decoration: TextDecoration.underline,
            paddingTop: 8,
            paddingBottom: 21,
            onTap: () => Get.to(() => OurJourney()),
          ),
          StoryCard(
            label: 'Our Story',
            title: 'The Clunky Spreadsheet',
            content:
                'Even before we had entered into the full swing of a new academic year, echoes energetically bounced off our campus walls. The consensus was that the year ahead would be a 40-week marathon and that we would all be at risk of burnout.\n\nI am hopelessly fascinated by the wonders of medicine and see it as an absolute privilege to maybe one day, apply what we have learnt to make a difference in patients\'lives. However, amongst the commotion of the year, would other activities that I uphold with great importance subtly dwindle and fall by the wayside?....',
            haveBottomText: true,
            textColor: kSecondaryColor,
            bgColor: kDarkGreyColor2,
            onBottomTextTap: () => Get.to(() => OurStory()),
          ),
          StoryCard(
            label: 'Acknowledgement',
            content:
                'I would like to acknowledge my brother Timothy and my colleague Claudia who has been by my side from the very beginning. Thank you for the unrelenting commitment that you have shown, and the countless hours that you have spent, to help bring LifeBerg to fruition. Your support has been invaluable, and oftentimes instrumental, in pushing us through the many ruts along the road.\nI would also like to thank my family for their unwavering support on the sidelines as well as the Lord for His grace and sovereignty in seeing this project through each and every step of the way.\n\nLastly, on behalf of the LifeBerg team, I would like to thank all medical students, doctors and friends who have very generously donated their time to provide us with much valuable feedback and advice along the way. You have well and truely helped to shape LifeBerg into the tool that it has become and we sincerely hope that you will continue on this journey with us well into the future.',
            textColor: kBlackColor,
            bgColor: kSecondaryColor,
          ),
          SizedBox(
            height: 16,
          ),
          Image.asset(
            Assets.imagesTeamwork,
            height: 231,
          ),
          MyText(
            text:
                '“We support the holistic wellbeing of medical students, doctors and non-medical individuals so that they can, in turn, care for those around them.” ',
            size: 12,
            weight: FontWeight.w500,
            fontStyle: FontStyle.italic,
            align: TextAlign.center,
            height: 1.6,
            paddingBottom: 25,
          ),
          Image.asset(
            Assets.imagesLogo2,
            height: 40,
          )
        ],
      ),
    );
  }
}
