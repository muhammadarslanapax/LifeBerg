import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/journey_card.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

class OurJourney extends StatelessWidget {
  const OurJourney({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldColor,
      appBar: simpleAppBar(
        title: 'Our Journey',
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(15),
        children: [
          MainHeading(
            text: 'Journey Timeline',
            paddingBottom: 10,
          ),
          JourneyCard(
            icon: Assets.imagesSpiral,
            content:
                'It all began with a pain point - the challenges of juggling medical school with church activities, work, time for others, life admin tasks, projects, exercise and self care.\n\nThere was no app that ticked all the boxes...and so the journey began.',
            haveBottomIcon: true,
            bgColor: kLightGreenColor,
            bottomIcon: Assets.imagesLeftLineArrow,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: Get.width,
                padding: EdgeInsets.fromLTRB(15, 17, 15, 30),
                decoration: BoxDecoration(
                  color: kPeachColor,
                  borderRadius: BorderRadius.circular(7),
                  image: DecorationImage(
                    image: AssetImage(
                      Assets.imagesBorder,
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      Assets.imagesGlasses,
                      height: 70,
                    ),
                    MyText(
                      text:
                          'We established our vision, values and purpose which is to\n',
                      size: 13,
                      color: kBlackColor,
                      height: 1.5,
                      paddingTop: 8,
                    ),
                    MyText(
                      text:
                          '“support the holistic wellbeing of others so that they can care for those around them”',
                      size: 13,
                      color: kBlackColor,
                      height: 1.5,
                      fontStyle: FontStyle.italic,
                      paddingTop: 8,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    Assets.imagesRightLineArrow,
                    height: 38,
                  ),
                ),
              ),
            ],
          ),
          JourneyCard(
            icon: Assets.imagesKey,
            content:
                'We bounced our ideas off family, friends, colleagues, complete strangers and medical organisations.\n\nWith time, the features of the app organically evolved as we crafted our wireframes and the clickable prototype.',
            haveBottomIcon: true,
            bgColor: kLightChoclateColor,
            bottomIcon: Assets.imagesLeftLineArrow,
          ),
          JourneyCard(
            icon: Assets.imagesMessage,
            content:
                'Our clickable prototype was formally presented to doctors and medical students across 4 hospitals and 1 medical school in Australia as well as on a one-on-one basis with medical and non-medical individuals.\n\nLifeBerg dynamically evolved over these 7 months.',
            haveBottomIcon: true,
            bgColor: kSkyBlueColor,
            bottomIcon: Assets.imagesRightLineArrow,
            bottomIconAlign: Alignment.centerRight,
          ),
          JourneyCard(
            icon: Assets.imagesRocket,
            content:
                'Once we reached saturation with users’ feedback, we took the plunge and developed LifeBerg.\n\nWe hope that you will gain much from the app and continue forward on this journey with us. ',
            haveBottomIcon: false,
            bgColor: kLightPurpleColor2,
            bottomIcon: Assets.imagesRightLineArrow,
          ),
        ],
      ),
    );
  }
}
