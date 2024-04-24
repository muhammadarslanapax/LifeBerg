import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/screens/journal/journal_tabs/add_new_gratitude.dart';
import 'package:life_berg/view/widget/choose_color.dart';
import 'package:life_berg/view/widget/custom_bottom_sheet.dart';
import 'package:life_berg/view/widget/custom_check_box_tile.dart';
import 'package:life_berg/view/widget/dialog_action_button.dart';
import 'package:life_berg/view/widget/gratitude_widget.dart';
import 'package:life_berg/view/widget/image_dialog.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/menu_item.dart';
import 'package:life_berg/view/widget/my_dialog.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';
import 'package:life_berg/view/widget/past_entries_widget.dart';
import 'package:life_berg/view/widget/search_bar.dart';
import 'package:life_berg/view/widget/time_line_indicator.dart';
import 'package:timelines/timelines.dart';

class Gratitudes extends StatefulWidget {
  @override
  State<Gratitudes> createState() => _GratitudesState();
}

class _GratitudesState extends State<Gratitudes> {
  bool showResults = false;

  Offset _tapPosition = Offset.zero;

  void _getTapPosition(TapDownDetails tapPosition) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = referenceBox.globalToLocal(tapPosition.globalPosition);
      print(_tapPosition);
    });
  }

  void _showContextMenu(BuildContext context) async {
    final RenderObject? overlay =
        Overlay.of(context)?.context.findRenderObject();
    final result = await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 100, 100),
        Rect.fromLTWH(
          0,
          -40,
          overlay!.paintBounds.size.width,
          overlay.paintBounds.size.height,
        ),
      ),
      elevation: 10,
      constraints: BoxConstraints(
        maxWidth: 170,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      items: [
        menuItem(
          icon: Assets.imagesEditItem,
          title: 'Edit Gratitude',
          onTap: () {},
        ),
        menuItem(
          title: 'Delete Gratitude',
          icon: Assets.imagesDeleteThisItem,
          borderColor: Colors.transparent,
          onTap: () {
            Get.dialog(
              MyDialog(
                icon: Assets.imagesDeleteThisItem,
                heading: 'Delete Gratitude',
                content:
                    'Are you sure? The selected item will be deleted. To revert changes click undo.',
                haveCustomActionButtons: true,
                customAction: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DialogActionButton(
                      text: 'Undo',
                      textColor: kRedColor,
                      onTap: () => Get.back(),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    DialogActionButton(
                      text: 'Delete',
                      onTap: () => Get.back(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
          children: [
            Row(
              children: [
                Expanded(
                  child: SearchBarDAR(
                    onChanged: (v) {
                      setState(() {
                        v.length > 0 ? showResults = true : showResults = false;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 8.5,
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (_) {
                        return CustomBottomSheet(
                          height: 360,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                MainHeading(
                                  text: 'Sort by',
                                ),
                                SizedBox(height: 16,),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: List.generate(
                                      3,
                                      (index) {
                                        List<String> _items = [
                                          'Newest',
                                          'Oldest',
                                          'Colour on timeline',
                                          // 'Length (>100 words)',
                                        ];
                                        return CustomCheckBoxTile(
                                          title: _items[index],
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
                    Assets.imagesFilterButtom,
                    height: 17,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            if (showResults == true)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MainHeading(
                    text: 'Search Results',
                    paddingBottom: 10,
                  ),
                  Column(
                    children: List.generate(
                      3,
                      (index) {
                        return GestureDetector(
                          onTapDown: (position) => {
                            _getTapPosition(position),
                          },
                          onLongPress: () => _showContextMenu(context),
                          child: PastEntryWidget(
                            title: index == 0 ? 'Charlie’s Birth' : 'Code Blue',
                            subTitle: index == 0
                                ? 'Now I can see that...'
                                : index == 1
                                    ? ''
                                    : 'Angela and Lee finally arrived after rescheduling their... ',
                            time: 'October 27, 2008',
                            image: '',
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            else
              FixedTimeline.tileBuilder(
                theme: TimelineThemeData(
                  nodePosition: 0,
                  connectorTheme: ConnectorThemeData(
                    color: kTextColor,
                    thickness: 1.0,
                  ),
                ),
                builder: TimelineTileBuilder(
                  itemCount: 10,
                  contentsBuilder: (_, index) {
                    return GestureDetector(
                      onTapDown: (position) => {
                        _getTapPosition(position),
                      },
                      onLongPress: () => _showContextMenu(context),
                      child: GratitudeWidget(
                        gratitudes: [
                          'Bailey’s vet appointment went well - E-collar removed!',
                          'Missed a close collision on the road',
                        ],
                        time: 'October 27, 2008',
                      ),
                    );
                  },
                  indicatorBuilder: (context, index) {
                    return TimeLineIndicator(
                      color: index == 0
                          ? kNavyBlueColor
                          : index == 1
                              ? kDarkBlueColor
                              : index == 2
                                  ? kCardio2Color
                                  : kStreaksColor,
                    );
                  },
                  // indicatorPositionBuilder: (context, index) {
                  //   return index == 0 ? 0.0 : 0.2;
                  // },
                  startConnectorBuilder: (_, index) => Connector.solidLine(
                    color: kBorderColor,
                    thickness: 4.0,
                  ),
                  endConnectorBuilder: (_, index) => Connector.solidLine(
                    color: kBorderColor,
                    thickness: 4.0,
                  ),
                ),
              ),
          ],
        ),
        Positioned(
          bottom: 15,
          right: 15,
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                builder: (_) {
                  return AddNewGratitude();
                },
              );
            },
            child: Image.asset(
              Assets.imagesAddButton,
              height: 44,
            ),
          ),
        ),
      ],
    );
  }
}

class AddNewGratitude extends StatefulWidget {
  AddNewGratitude({
    Key? key,
  }) : super(key: key);

  @override
  State<AddNewGratitude> createState() => _AddNewGratitudeState();
}

class _AddNewGratitudeState extends State<AddNewGratitude> {
  final List<Color> colors = [
    kC1,
    kC2,
    kC3,
    kC4,
    kC5,
    kC6,
    kC7,
    kC8,
    kC9,
    kC10,
    kC11,
    kC12,
    kC13,
    kQuiteTimeColor,
    kDarkBlueColor,
    kC16,
  ];

  int colorIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: CustomBottomSheet(
        height: 380,
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 6,
          ),
          children: [
            MainHeading(
              text: 'What are you grateful for?',
              paddingBottom: 12,
            ),
            MyTextField(
              // onTap: () => Get.to(() => AddGratitude()),
              // isReadOnly: true,
              hint: 'Reflect away...',
              marginBottom: 26,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MainHeading(
                  text: 'Colour on timeline',
                  paddingBottom: 12,
                ),
                ChooseColor(
                  colors: colors,
                  colorIndex: colorIndex,
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          Get.dialog(
            ImageDialog(
              heading: 'Gratitude Saved!',
              content: '',
              image: Assets.imagesGratitudeSaved,
              imageSize: 116,
              onOkay: () {
                Get.back();
                Navigator.pop(context);
              },
            ),
          );
        },
        buttonText: 'Submit',
        isButtonDisable: false,
      ),
    );
  }
}
