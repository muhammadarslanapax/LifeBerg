import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeLineIndicator extends StatelessWidget {
  const TimeLineIndicator({
    Key? key,
    required this.color,
  }) : super(key: key);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      width: 18,
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          height: Get.height,
          width: Get.width,
        ),
      ),
    );
  }
}
