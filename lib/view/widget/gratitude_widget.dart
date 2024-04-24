import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/widget/my_text.dart';

class GratitudeWidget extends StatelessWidget {
  GratitudeWidget({
    Key? key,
    required this.gratitudes,
    required this.time,
  }) : super(key: key);
  final List<String> gratitudes;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 4,
        bottom: 8,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: kSecondaryColor,
        border: Border.all(
          width: 1.0,
          color: kBorderColor,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(
                    gratitudes.length,
                    (index) {
                      return MyText(
                        paddingBottom: 4,
                        text: '•  ${gratitudes[index]}',
                        size: 12,
                        height: 1.8,
                      );
                    },
                  ),
                ),
                MyText(
                  paddingTop: 4,
                  text: time,
                  size: 10,
                  color: kDarkBlueColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
