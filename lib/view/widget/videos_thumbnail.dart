import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/utils/instance.dart';
import 'package:life_berg/view/widget/common_image_view.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class VideoThumbnail extends StatelessWidget {
  const VideoThumbnail({
    Key? key,
    required this.title,
    required this.duration,
    required this.onPlayTap,
    required this.img,
    required this.itemCount,
    required this.onTap,
    required this.subTitle,
    required this.tags,
  }) : super(key: key);

  final String img, title, subTitle, duration;
  final VoidCallback onPlayTap, onTap;
  final int itemCount;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Stack(
          children: [
            CommonImageView(
              height: Get.height,
              width: Get.width,
              radius: 8.0,
              url: img,
            ),
            Container(
              padding: EdgeInsets.all(15),
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
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
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              MyText(
                                text: title,
                                size: 16,
                                weight: FontWeight.w500,
                                color: kSecondaryColor,
                                paddingBottom: 5,
                              ),
                              MyText(
                                text: subTitle,
                                size: 10,
                                color: kSecondaryColor,
                                paddingBottom: 10,
                              ),
                              Row(
                                children: [
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    spacing: 6.0,
                                    children: List.generate(
                                      2,
                                      (index) {
                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: kSecondaryColor,
                                            border: Border.all(
                                              width: 1.0,
                                              color: kBorderColor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: MyText(
                                            text: tags[index],
                                            size: 12,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  MyText(
                                    text: '   •   $duration ',
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
                          mainAxisAlignment: MainAxisAlignment.end,
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
                                  onTap: onPlayTap,
                                  child: Image.asset(
                                    Assets.imagesPlay,
                                    color: kSecondaryColor,
                                    height: 24,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            SmoothPageIndicator(
                              controller:
                                  pDevController.videoPageController,
                              count: itemCount,
                              effect: ExpandingDotsEffect(
                                dotHeight: 8,
                                dotWidth: 8,
                                spacing: 5.0,
                                activeDotColor: kSecondaryColor,
                                dotColor: kSecondaryColor.withOpacity(0.2),
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
    );
  }
}
