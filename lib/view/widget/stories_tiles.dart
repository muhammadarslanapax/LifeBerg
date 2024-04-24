import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/common_image_view.dart';
import 'package:life_berg/view/widget/my_text.dart';

class StoriesTiles extends StatelessWidget {
  const StoriesTiles({
    Key? key,
    required this.img,
    required this.type,
    required this.title,
    required this.postedTime,
    required this.onBookmark,
    required this.duration,
    required this.onTap,
    required this.isVideo,
  }) : super(key: key);

  final String img, type, title, postedTime, duration;
  final VoidCallback onBookmark, onTap;
  final bool isVideo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 10,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: kSecondaryColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 1.0,
            color: kBorderColor,
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Stack(
                children: [
                  CommonImageView(
                    height: 64,
                    width: 64,
                    radius: 8.0,
                    imagePath: img,
                  ),
                  Positioned(
                    bottom: 3,
                    left: 3,
                    child: Image.asset(
                      isVideo
                          ? Assets.imagesPlayIconNew
                          : Assets.imagesArticleIconNew,
                      height: 24,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: type,
                      size: 10,
                    ),
                    MyText(
                      text: title,
                      size: 12,
                      weight: FontWeight.w500,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              MyText(
                                text: '$postedTime   •   $duration ',
                                size: 12,
                              ),
                              Image.asset(
                                Assets.imagesClock,
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: onBookmark,
                          child: Image.asset(
                            Assets.imagesBookmarkEmpty,
                            height: 20,
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
      ),
    );
  }
}
