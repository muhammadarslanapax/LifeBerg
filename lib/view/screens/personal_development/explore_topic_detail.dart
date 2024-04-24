import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/main.dart';
import 'package:life_berg/utils/instance.dart';
import 'package:life_berg/view/screens/personal_development/story_detail.dart';
import 'package:life_berg/view/widget/custom_bottom_sheet.dart';
import 'package:life_berg/view/widget/custom_check_box_tile.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/search_bar.dart';
import 'package:life_berg/view/widget/stories_tiles.dart';
import 'package:life_berg/view/widget/videos_thumbnail.dart';

// ignore: must_be_immutable
class ExploreTopicDetail extends StatelessWidget {
  ExploreTopicDetail({
    this.title,
  });

  String? title = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      appBar: AppBar(
        backgroundColor: kSecondaryColor,
        elevation: 1,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Image.asset(
                Assets.imagesArrowBack,
                height: 24,
              ),
            ),
          ],
        ),
        title: MyText(
          text: title,
          size: 16,
          weight: FontWeight.w500,
          color: kTextColor,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 15,
            ),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (_) {
                      return CustomBottomSheet(
                        height: 340,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              MyText(
                                paddingBottom: 15,
                                text: 'Sort by',
                                size: 20,
                                weight: FontWeight.w500,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: List.generate(
                                    3,
                                    (index) {
                                      return CustomCheckBoxTile(
                                        title: index == 0
                                            ? 'Popular'
                                            : index == 1
                                                ? 'Newest'
                                                : 'Oldest',
                                        isSelected: index == 0 ? true : false,
                                        onSelect: () {},
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () => Get.back(),
                        buttonText: 'Confirm',
                        isButtonDisable: false,
                      );
                    },
                  );
                },
                child: Image.asset(
                  Assets.imagesFilterIcon,
                  height: 24,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          vertical: 15,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: SearchBarDAR(),
          ),
          MyText(
            paddingLeft: 15,
            paddingTop: 5,
            paddingBottom: 15,
            text: 'Featured',
            size: 20,
            weight: FontWeight.w500,
          ),
          Container(
            height: 200,
            child: PageView.builder(
              controller: pDevController.videoPageController,
              onPageChanged: (index) =>
                  pDevController.onVideoPageChanged(index),
              physics: BouncingScrollPhysics(),
              itemCount: 3,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return VideoThumbnail(
                  itemCount: 3,
                  img: dummyImg3,
                  title: 'Almonds: Do they help?',
                  subTitle: 'How did people got interested in almonds?',
                  duration: '4 min',
                  tags: [
                    'Food',
                    'Health & Care',
                  ],
                  onPlayTap: () {},
                  onTap: () {},
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyText(
                  paddingTop: 20,
                  paddingBottom: 15,
                  text: 'Stories',
                  size: 20,
                  weight: FontWeight.w500,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return StoriesTiles(
                      isVideo: index.isEven,
                      img: Assets.imagesMedSchool,
                      type: 'Med School',
                      title:
                          'What I have learnt as a new dad in medical school',
                      postedTime: '1 day ago',
                      duration: '4 min',
                      onBookmark: () {},
                      onTap: () => Get.to(() => StoryDetail()),
                    );
                  },
                ),
                MyText(
                  paddingTop: 10,
                  paddingBottom: 30,
                  text: 'See All',
                  size: 16,
                  color: kTertiaryColor,
                  align: TextAlign.end,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
