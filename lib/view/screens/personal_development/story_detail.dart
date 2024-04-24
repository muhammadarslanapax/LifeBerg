import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/main.dart';
import 'package:life_berg/view/widget/common_image_view.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

class StoryDetail extends StatefulWidget {
  @override
  State<StoryDetail> createState() => _StoryDetailState();
}

class _StoryDetailState extends State<StoryDetail> {
  bool readMore = false;

  void onReadMore() {
    setState(() {
      readMore = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      appBar: simpleAppBar(
        title: 'Stories',
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            height: 200,
            child: Stack(
              children: [
                CommonImageView(
                  height: Get.height,
                  width: Get.width,
                  radius: 0.0,
                  url: dummyImg3,
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  height: Get.height,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: kBlackColor.withOpacity(0.6),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  MyText(
                                    text: 'On the Go Snack Ideas',
                                    size: 16,
                                    weight: FontWeight.w500,
                                    color: kSecondaryColor,
                                    paddingBottom: 8,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: 35,
                                        width: 51,
                                        decoration: BoxDecoration(
                                          color: kSecondaryColor,
                                          border: Border.all(
                                            width: 1.0,
                                            color: kBorderColor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Center(
                                          child: MyText(
                                            text: 'Food',
                                            size: 12,
                                          ),
                                        ),
                                      ),
                                      MyText(
                                        text: '   •   4 min ',
                                        size: 12,
                                        color: kSecondaryColor,
                                      ),
                                      Image.asset(
                                        Assets.imagesClock,
                                        height: 12,
                                        color: kSecondaryColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: kTertiaryColor,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Image.asset(
                                        Assets.imagesBookmarkEmpty,
                                        color: kSecondaryColor,
                                        height: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MainHeading(
                  text: 'On the Go Snack Ideas',
                  paddingBottom: 8,
                ),
                MyText(
                  text:
                      'Lorem ipsum dolor sit amet consectetur. Condimentum orci vitae eu risus quis. Nisl ac vitae vel cras quis. Bibendum mauris vestibulum at faucibus. Sed massa morbi vitae mauris sed ac urna semper maecenas.\n\nLorem ipsum dolor sit amet consectetur. Et arcu mauris ut mattis amet risus dolor nullam. Nunc sem cras quisque ultrices faucibus at neque. Fringilla sit viverra sed egestas lacus. Adipiscing tellus et donec non eget consectetur proin orci non.',
                  size: 13,
                  height: 1.5,
                ),
                MainHeading(
                  paddingTop: 15,
                  paddingBottom: 8,
                  text: 'Do they have health benefits?',
                ),
                MyText(
                  text:
                      'Lorem ipsum dolor sit amet consectetur. Condimentum orci vitae eu risus quis. Nisl ac vitae vel cras quis. Bibendum mauris vestibulum at faucibus. Sed massa morbi vitae mauris sed ac urna semper maecenas.\n\nLorem ipsum dolor sit amet consectetur. Et arcu mauris ut mattis amet risus dolor nullam. Nunc sem cras quisque ultrices faucibus at neque. Fringilla sit viverra sed egestas lacus. Adipiscing tellus et donec non eget consectetur proin orci non.',
                  size: 13,
                  height: 1.5,
                  maxLines: readMore ? null : 12,
                ),
              ],
            ),
          ),
          MyText(
            onTap: () => onReadMore(),
            paddingTop: 10,
            paddingRight: 15,
            align: TextAlign.end,
            size: 16,
            color: kTertiaryColor,
            text: 'Read More',
          ),
        ],
      ),
    );
  }
}
