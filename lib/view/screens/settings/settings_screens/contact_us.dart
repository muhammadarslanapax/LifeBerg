// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

class ContactUs extends StatelessWidget {
  ContactUs({Key? key}) : super(key: key);

  List<String> socialIcons = [
    Assets.imagesFacebookNew,
    Assets.imagesInstagram,
    Assets.imagesYoutube,
    Assets.imagesLinkdin,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCoolGreyColor3,
      appBar: simpleAppBar(
        title: 'Contact Us',
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(15),
        children: [
          MainHeading(
            text: 'Email',
            paddingBottom: 8,
          ),
          ContactUsTile(
            icon: Assets.imagesContactEmail,
            title: 'CONNECT@lifeberg.app',
            subTitle: 'General Enquiries',
            onTap: () {},
          ),
          ContactUsTile(
            icon: Assets.imagesContactEmail,
            title: 'CONTENT@lifeberg.app',
            subTitle: 'Suggestions & contribution to LifeBerg content',
            onTap: () {},
          ),
          MainHeading(
            text: 'Social Media',
            paddingTop: 14,
            paddingBottom: 12,
          ),
          Wrap(
            spacing: 24,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: List.generate(
              socialIcons.length,
              (index) => Image.asset(
                socialIcons[index],
                height: index == 2 ? 25 : 35,
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Image.asset(
            Assets.imagesMailSent,
            height: 352,
          ),
        ],
      ),
    );
  }
}

class ContactUsTile extends StatelessWidget {
  ContactUsTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.subTitle,
  }) : super(key: key);

  final String icon, title, subTitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      margin: EdgeInsets.only(
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 1.0,
          color: kBorderColor,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                icon,
                height: 24,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: title,
                      size: 16,
                      paddingBottom: 5,
                      paddingLeft: 10,
                    ),
                    MyText(
                      text: subTitle,
                      size: 12,
                      paddingTop: 4,
                      paddingLeft: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
