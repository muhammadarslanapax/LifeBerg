import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';

// ignore: must_be_immutable
class CustomSlider extends StatelessWidget {
  ValueChanged<double>? onChanged;
  double? value;

  CustomSlider({
    Key? key,
    this.onChanged,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 2,
        minThumbSeparation: 0.0,
        overlayShape: RoundSliderOverlayShape(
          overlayRadius: 0.0,
        ),
        thumbShape: RoundSliderThumbShape(
          enabledThumbRadius: 5,
        ),
        overlayColor: Colors.transparent,
        overlappingShapeStrokeColor: Colors.transparent,
        trackShape: CustomTrackShape(),
      ),
      child: Slider(
        onChanged: onChanged,
        value: value ?? 0,
        min: 0,
        max: 100,
        activeColor: kDarkBlueColor,
        inactiveColor: kUnSelectedColor,
      ),
    );
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
