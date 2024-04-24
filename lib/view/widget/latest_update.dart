import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/utils/instance.dart';
import 'package:life_berg/view/widget/common_image_view.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LatestUpdate extends StatelessWidget {
  const LatestUpdate({
    Key? key,
    required this.title,
    required this.tag,
    required this.duration,
    required this.onBookmark,
    required this.img,
    required this.itemCount, required this.onTap,
  }) : super(key: key);

  final String img, title, tag, duration;
  final VoidCallback onBookmark,onTap;
  final int itemCount;

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
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              MyText(
                                text: title,
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
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Center(
                                      child: MyText(
                                        text: tag,
                                        size: 12,
                                      ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  onTap: onBookmark,
                                  child: Image.asset(
                                    Assets.imagesBookmarkEmpty,
                                    color: kSecondaryColor,
                                    height: 24,
                                  ),
                                ),
                              ),
                            ),
                            SmoothPageIndicator(
                              controller:
                                  pDevController.latestUpdatePageController,
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
