import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/my_text.dart';

class MyExpandableTiles extends StatelessWidget {
  MyExpandableTiles({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);
  final String title;
  final List<MyExpandableTileItem> children;
  final ExpandableController controller = ExpandableController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 8,
      ),
      padding: EdgeInsets.only(
        bottom: 10,
      ),
      child: ExpandableNotifier(
        controller: controller,
        child: ScrollOnExpand(
          scrollOnExpand: true,
          scrollOnCollapse: false,
          child: ExpandablePanel(
            theme: const ExpandableThemeData(
              iconColor: kTextColor,
              hasIcon: false,
              headerAlignment: ExpandablePanelHeaderAlignment.center,
              tapBodyToCollapse: true,
            ),
            header: Container(
              height: 47,
              padding: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  width: 1.0,
                  color: kBorderColor,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                        text: '$title',
                        weight: FontWeight.w500,
                        size: 14,
                      ),
                      Image.asset(
                        controller.expanded
                            ? Assets.imagesArrowUp
                            : Assets.imagesArrowDown,
                        height: 24,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            collapsed: SizedBox(),
            expanded: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: children,
            ),
            builder: (_, collapsed, expanded) {
              return Expandable(
                collapsed: collapsed,
                expanded: expanded,
                theme: const ExpandableThemeData(
                  crossFadePoint: 0,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class MyExpandableTileItem extends StatelessWidget {
  const MyExpandableTileItem({
    Key? key,
    required this.value,
    required this.onTap,
  }) : super(key: key);

  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: MyText(
        paddingTop: 6,
        text: value,
        size: 11.5,
        height: 1.7,
        color: kTextColor,
      ),
    );
  }
}
