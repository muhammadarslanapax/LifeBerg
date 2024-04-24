import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/screens/personal_development/story_detail.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/stories_tiles.dart';

class SearchResultStories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(15),
      physics: BouncingScrollPhysics(),
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: 6,
          itemBuilder: (context, index) {
            return StoriesTiles(
              isVideo: index.isEven,
              img: Assets.imagesMedSchool,
              type: 'Med School',
              title: 'What I have learnt as a new dad in medical school',
              postedTime: '1 day ago',
              duration: '4 min',
              onBookmark: () {},
              onTap: () => Get.to(() => StoryDetail()),
            );
          },
        ),
        MyText(
          paddingTop: 10,
          text: 'See All',
          size: 16,
          color: kTertiaryColor,
          align: TextAlign.end,
        ),
      ],
    );
  }
}
