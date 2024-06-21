import 'package:flutter/material.dart';

Color hexToColor(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

String colorToHex(Color color) {
  return '#'
      '${color.alpha.toRadixString(16).padLeft(2, '0')}'
      '${color.red.toRadixString(16).padLeft(2, '0')}'
      '${color.green.toRadixString(16).padLeft(2, '0')}'
      '${color.blue.toRadixString(16).padLeft(2, '0')}';
}

const kPrimaryColor = Color(0xffF9FAFB);
const kLightPrimaryColor = Color(0xffD8E8FC);
const kSecondaryColor = Color(0xffFFFFFF);
const kPrimaryTextColor = Color(0xff1C1B1F);
const kTertiaryColor = Color(0xff377FAA);
const kBorderColor = Color(0xffE2E8F0);
const kTextColor = Color(0xff343B49);
const kSplashBgColor = Color(0xffE6EDFC);
const kLightPurpleColor = Color(0xffADC4F4);
const kLightGreyColor = Color(0xffFFFBFE);
const kPopupTextColor = Color(0xff49454F);
const kDarkGreyColor = Color(0xff343434);
const kSeoulColor = Color(0xffF9F9F9);
const kSeoulColor2 = Color(0xffEFF3FD);
const kCoolGreyColor = Color(0xff323F4B);
const kCoolGreyColor2 = Color(0xffF8F9FA);
const kCoolGreyColor3 = Color(0xffEAEEF6);
const kBlackColor = Color(0xff000000);
const kUnSelectedColor = Color(0xffDCEAF2);
const kRedColor = Color(0xffFF4B26);
const kDarkRedColor = Color(0xffC5513D);
const kBlueColor = Color(0xff4EA2FF);
const kMaroonColor = Color(0xffC7598E);
const kStreaksColor = Color(0xff00BAC7);
const kStreaksBgColor = Color(0xffF5FCFD);
const kWellBeingColor = Color(0xff3BCAD4);
const kCardioColor = Color(0xff7274F3);
const kDarkBlueColor = Color(0xff4E94BE);
const kChartBorderColor = Color(0xffF4F4F6);
const kChartLabelColor = Color(0xff7B8794);
const kSecondaryTextColor = Color(0xff75767F);

const kDailyGratitudeColor = Color(0xffA98FE3);
const kDailyGratitudeBgColor = Color(0xffF6F4FC);
const kQuiteTimeColor = Color(0xff00BAC7);
const kRACGPExamColor = Color(0xffF19D9C);
const kRACGPBGExamColor = Color(0xffFEF5F5);
const kDayStepColor = Color(0xffFED189);
const kDayStepLightColor = Color(0xffFFFAF3);
const kCardio2Color = Color(0xffF19D9C);
const kLifeBergBlueColor = Color(0xffADC4F4);
const kMapMarkerBorderColor = Color(0xffD2EAF7);
const kTabIndicatorColor = Color(0xffFED189);
const kInputFillColor = Color(0xffF7F9FE);
const kNavyBlueColor = Color(0xff2358C9);


const kLightGreenColor = Color(0xffAED0C1);
const kDarkGreyColor2 = Color(0xff747F95);
const kScaffoldColor = Color(0xffD5DFF4);
const kPeachColor = Color(0xffEEC9B0);
const kSkyBlueColor = Color(0xff9ED1EF);

var kLightPurpleColor2 = Color(0xffA5A6F6).withOpacity(0.24);
var kLightChoclateColor = Color(0xffD08F8B).withOpacity(0.80);




const kC1 = Color(0xffD1CFCD);
const kC2 = Color(0xffF69DB3);
const kC3 = Color(0xffFDCA77);
const kC4 = Color(0xffFBF686);
const kC5 = Color(0xffB6E0B7);
const kC6 = Color(0xffC7ECEE);
const kC7 = Color(0xffADC4F4);
var kC8 = const Color(0xff533A9D).withOpacity(0.42);
const kC9 = Color(0xff5C5E65);
const kC10 = Color(0xffEE2456);
const kC11 = Color(0xffF7904C);
const kC12 = Color(0xffBDAC97);
const kC13 = Color(0xff659B65);
const kC15 = Color(0xff659B65);
const kC16 = Color(0xff9475DB);
