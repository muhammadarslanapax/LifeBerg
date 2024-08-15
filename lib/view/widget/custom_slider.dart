import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';

// ignore: must_be_immutable
class CustomSlider extends StatelessWidget {
  ValueChanged<double>? onChanged;
  RxDouble? value = 0.0.obs;
  RxBool? isSkipped = false.obs;

  CustomSlider({
    Key? key,
    this.onChanged,
    this.value,
    this.isSkipped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => SfSliderTheme(
      data: SfSliderThemeData(
        activeTrackHeight: 4,
        inactiveTrackHeight: 4,
        thumbRadius: 4,
        overlayRadius: 8
      ),
      child: SfSlider(
        value: value!.value,
        min: 0.0,
        max: 10.0,
        activeColor: kDarkBlueColor,
        inactiveColor: kUnSelectedColor,
        onChanged: isSkipped!.value == false
            ? (value) {
          onChanged!(value);
        }
            : null,
      ),
    ));
    return Obx(() => SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
            minThumbSeparation: 0.0,
            overlayShape: RoundSliderOverlayShape(
              overlayRadius: 4.0,
            ),
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: 5,
            ),
            overlayColor: Colors.transparent,
            overlappingShapeStrokeColor: Colors.transparent,
            trackShape: CustomTrackShape(),
          ),
          child: Slider(
            onChanged: isSkipped!.value == false
                ? (value) {
                    onChanged!(value);
                  }
                : null,
            value: value!.value ?? 0,
            min: 0,
            max: 10,
            activeColor: kDarkBlueColor,
            inactiveColor: kUnSelectedColor,
          ),
        ));
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double? trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(
      trackLeft,
      trackTop!,
      trackWidth,
      trackHeight,
    );
  }
}
