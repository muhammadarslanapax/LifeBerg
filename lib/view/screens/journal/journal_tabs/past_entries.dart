import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/main.dart';
import 'package:life_berg/view/widget/choose_color.dart';
import 'package:life_berg/view/widget/common_image_view.dart';
import 'package:life_berg/view/widget/custom_bottom_sheet.dart';
import 'package:life_berg/view/widget/custom_check_box_tile.dart';
import 'package:life_berg/view/widget/dialog_action_button.dart';
import 'package:life_berg/view/widget/image_dialog.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/menu_item.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_calender.dart';
import 'package:life_berg/view/widget/my_dialog.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';
import 'package:life_berg/view/widget/past_entries_widget.dart';
import 'package:life_berg/view/widget/search_bar.dart';
import 'package:life_berg/view/widget/time_line_indicator.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:timelines/timelines.dart';

class PastEntries extends StatefulWidget {
  @override
  State<PastEntries> createState() => _PastEntriesState();
}

class _PastEntriesState extends State<PastEntries> {
  double? _distanceToField;

  TextfieldTagsController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  /*@override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }*/

  @override
  void initState() {
    super.initState();
    _controller = TextfieldTagsController();
  }

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
          title: 'Edit Entry',
          onTap: () {
            setState(() {
              Get.back();
              showEditEntry = true;
            });
          },
        ),
        menuItem(
          title: 'Delete Entry',
          icon: Assets.imagesDeleteThisItem,
          borderColor: Colors.transparent,
          onTap: () {
            Get.dialog(
              MyDialog(
                icon: Assets.imagesDeleteThisItem,
                heading: 'Delete Journal Entry',
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

  bool showEntryDetail = false;
  bool showEditEntry = false;

  final pageController = PageController();

  void _onNext() {
    pageController.nextPage(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _onBack() {
    pageController.previousPage(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return showEntryDetail
        ? pastEntryDetail()
        : showEditEntry
            ? editEntry()
            : ListView(
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
                              v.length > 0
                                  ? showResults = true
                                  : showResults = false;
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
                                height: 400,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      MainHeading(
                                        text: 'Sort by',
                                      ),SizedBox(height: 16,),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: List.generate(
                                            4,
                                            (index) {
                                              List<String> _items = [
                                                'Newest',
                                                'Oldest',
                                                'Colour on timeline',
                                                'Length (>100 words)',
                                              ];
                                              return CustomCheckBoxTile(
                                                title: _items[index],
                                                isSelected:
                                                    index == 0 ? true : false,
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
                                  title: index == 0
                                      ? 'Charlie’s Birth'
                                      : 'Code Blue',
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
                            onTap: () {
                              setState(() {
                                showEntryDetail = true;
                              });
                            },
                            onTapDown: (position) => {
                              _getTapPosition(position),
                            },
                            onLongPress: () => _showContextMenu(context),
                            child: PastEntryWidget(
                              title:
                                  index == 0 ? 'Charlie’s Birth' : 'Code Blue',
                              subTitle: index == 0
                                  ? 'Now I can see that...'
                                  : index == 1
                                      ? ''
                                      : 'Angela and Lee finally arrived after rescheduling their... ',
                              time: 'October 27, 2008',
                              image: index == 3 ? '' : dummyImg3,
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
                        startConnectorBuilder: (_, index) =>
                            Connector.solidLine(
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
              );
  }

  Widget pastEntryDetail() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RotatedBox(
                    quarterTurns: 2,
                    child: GestureDetector(
                      onTap: () => _onBack(),
                      child: Image.asset(
                        Assets.imagesArrowNext,
                        height: 24,
                        color: kDarkBlueColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: pageController,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          height: Get.height,
                          width: Get.width,
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 12,
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.0,
                              color: Color(0xffE2E8F0),
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: BouncingScrollPhysics(),
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        MyText(
                                          text: 'Charlie’s Birth',
                                          size: 16,
                                          weight: FontWeight.w500,
                                        ),
                                        MyText(
                                          text: 'October 27, 2008',
                                          size: 11,
                                          paddingTop: 4,
                                          color: kDarkBlueColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showEditEntry = true;
                                        showEntryDetail = false;
                                      });
                                    },
                                    child: Image.asset(
                                      Assets.imagesEditItem,
                                      height: 16,
                                      color: Color(0xff7B8794),
                                    ),
                                  ),
                                ],
                              ),
                              MyText(
                                paddingTop: 6,
                                paddingBottom: 16,
                                text:
                                    'Lorem ipsum dolor sit amet consectetur. Euismod sollicitudin nisl metus auctor diam. Orci habitant gravida elit quis. Elit in lobortis quis ut sit. Amet duis laoreet egestas amet. Nunc mattis vel nam morbi. Bibendum porta fringilla mi vitae a.\nLorem ipsum dolor sit amet consectetur. Euismod sollicitudin nisl metus auctor diam. Orci habitant gravida elit quis. Elit in lobortis quis ut sit. Amet duis laoreet egestas amet.',
                                size: 12,
                                height: 1.8,
                                color: Color(0xff323F4B),
                              ),
                              CommonImageView(
                                height: 150,
                                width: Get.width,
                                radius: 8.0,
                                url: dummyImg3,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _onNext(),
                    child: Image.asset(
                      Assets.imagesArrowNext,
                      height: 24,
                      color: kDarkBlueColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(15),
          child: MyButton(
            text: 'Return',
            onTap: () {
              setState(() {
                showEntryDetail = false;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget editEntry() {
    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
      children: [
        MyTextField(
          hint: 'Charlie’s Birth',
        ),
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            MyTextField(
              maxLines: 10,
              hint:
                  'Lorem ipsum dolor sit amet consectetur. Euismod sollicitudin nisl metus auctor diam. Orci habitant gravida elit quis. Elit in lobortis quis ut sit. Amet duis laoreet egestas amet. Nunc mattis vel nam morbi. Bibendum porta fringilla mi vitae a. away...',
            ),
            Positioned(
              left: 1,
              right: 1,
              bottom: 16,
              child: Container(
                height: 30,
                padding: EdgeInsets.only(
                  left: 14,
                ),
                width: Get.width,
                color: kSecondaryColor,
                alignment: Alignment.centerLeft,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 14,
                  children: [
                    Image.asset(
                      Assets.imagesBold,
                      height: 20,
                      color: kDarkBlueColor,
                    ),
                    Image.asset(
                      Assets.imagesItalic,
                      height: 20,
                      color: kDarkBlueColor,
                    ),
                    Image.asset(
                      Assets.imagesListUl,
                      height: 20,
                      color: kDarkBlueColor,
                    ),
                    Image.asset(
                      Assets.imagesListOlAlt,
                      height: 16,
                      color: kDarkBlueColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // TextFieldTags(
        //   textfieldTagsController: _controller,
        //   initialTags: [],
        //   textSeparators: const [' ', ','],
        //   letterCase: LetterCase.normal,
        //   validator: (String tag) {
        //     if (tag == 'php') {
        //       return 'No, please just no';
        //     } else if (_controller!.getTags!.contains(tag)) {
        //       return 'you already entered that';
        //     }
        //     return null;
        //   },
        //   inputfieldBuilder: (context, tec, fn, error, onChanged, onSubmitted) {
        //     return ((context, sc, tags, onTagDelete) {
        //       return TextField(
        //         controller: tec,
        //         focusNode: fn,
        //         style: TextStyle(
        //           fontSize: 14,
        //           color: kTextColor,
        //         ),
        //         decoration: InputDecoration(
        //           hintStyle: TextStyle(
        //             fontSize: 14,
        //             color: kTextColor.withOpacity(0.50),
        //           ),
        //           contentPadding: EdgeInsets.symmetric(
        //             horizontal: 15,
        //           ),
        //           enabledBorder: OutlineInputBorder(
        //             borderRadius: BorderRadius.circular(8.0),
        //             borderSide: BorderSide(
        //               color: kBorderColor,
        //               width: 1.0,
        //             ),
        //           ),
        //           focusedBorder: OutlineInputBorder(
        //             borderRadius: BorderRadius.circular(8.0),
        //             borderSide: BorderSide(
        //               color: kBorderColor,
        //               width: 1.0,
        //             ),
        //           ),
        //           hintText: _controller!.hasTags ? '' : "Add Tags",
        //           errorText: error,
        //           prefixIconConstraints: BoxConstraints(
        //             maxWidth: _distanceToField! * 0.74,
        //           ),
        //           prefixIcon: tags.isNotEmpty
        //               ? SingleChildScrollView(
        //                   controller: sc,
        //                   scrollDirection: Axis.horizontal,
        //                   child: Row(
        //                       children: tags.map(
        //                     (String tag) {
        //                       return Container(
        //                         height: 36,
        //                         decoration: BoxDecoration(
        //                           color: kDarkBlueColor,
        //                           borderRadius: BorderRadius.circular(4),
        //                         ),
        //                         margin: EdgeInsets.symmetric(
        //                           horizontal: 4,
        //                         ),
        //                         padding: EdgeInsets.all(8),
        //                         child: Row(
        //                           children: [
        //                             MyText(
        //                               text: '$tag',
        //                               size: 12,
        //                               color: kSecondaryColor,
        //                               paddingRight: 8,
        //                             ),
        //                             GestureDetector(
        //                               onTap: () {
        //                                 onTagDelete(tag);
        //                               },
        //                               child: Image.asset(
        //                                 Assets.imagesRemoveTag,
        //                                 height: 16,
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                       );
        //                     },
        //                   ).toList()),
        //                 )
        //               : null,
        //         ),
        //         onChanged: onChanged,
        //         onSubmitted: onSubmitted,
        //       );
        //     });
        //   },
        // ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          onTap: () {},
          readOnly: true,
          textInputAction: TextInputAction.next,
          style: TextStyle(
            fontSize: 14,
            color: kTextColor,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            filled: true,
            fillColor: kSecondaryColor,
            hintText: 'Add Photos',
            hintStyle: TextStyle(
              fontSize: 14,
              color: kTextColor.withOpacity(0.50),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: kBorderColor,
                width: 1.0,
              ),
            ),
            prefixIcon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Assets.imagesAddImage,
                  height: 24,
                  color: Color(0xffD0D6DD),
                ),
              ],
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: kBorderColor,
                width: 1.0,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          readOnly: true,
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              elevation: 0,
              isScrollControlled: true,
              builder: (_) {
                return AddDate();
              },
            );
          },
          textInputAction: TextInputAction.next,
          style: TextStyle(
            fontSize: 14,
            color: kTextColor,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            filled: true,
            fillColor: kSecondaryColor,
            hintText: 'Adjust date',
            hintStyle: TextStyle(
              fontSize: 14,
              color: kTextColor.withOpacity(0.50),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: kBorderColor,
                width: 1.0,
              ),
            ),
            prefixIcon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Assets.imagesCalender,
                  height: 24,
                  color: kTextColor.withOpacity(0.4),
                  // color: Color(0xffD0D6DD),
                ),
              ],
            ),
            suffixIcon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.dialog(
                      MyDialog(
                        icon: Assets.imagesDeleteThisItem,
                        heading: 'Delete Journal Entry',
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
                  child: Image.asset(
                    Assets.imagesDeleteThisItem,
                    height: 24,
                    color: Color(0xffD0D6DD),
                  ),
                ),
              ],
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: kBorderColor,
                width: 1.0,
              ),
            ),
          ),
        ),
        MyText(
          paddingTop: 16,
          text: 'Colour on timeline',
          size: 18,
          weight: FontWeight.w500,
          color: kTextColor.withOpacity(0.6),
          paddingBottom: 12,
        ),
        ChooseColor(
          colors: colors,
          colorIndex: colorIndex,
        ),
        SizedBox(
          height: 24,
        ),
        MyButton(
          text: 'Submit',
          onTap: () {
            setState(() {
              Get.back();
              Get.dialog(
                ImageDialog(
                  heading: 'Journal Entry Saved!',
                  image: Assets.imagesJournalEntrySavedNewImage,
                  imageSize: 118.0,
                  content: '',
                  onOkay: () {
                    setState(() {
                      Get.back();
                      showEntryDetail = false;
                    });
                  },
                ),
              );
              showEditEntry = false;
              showEntryDetail = true;
            });
          },
        ),
        SizedBox(
          height: 24,
        ),
      ],
    );
  }
}

class AddDate extends StatelessWidget {
  const AddDate({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      height: Get.height * 0.72,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MainHeading(
            paddingLeft: 15,
            text: 'Adjust date',
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(0, 6, 0, 15),
              children: [
                MyCalender(),
              ],
            ),
          ),
        ],
      ),
      onTap: () => Get.back(),
      buttonText: 'Confirm',
      isButtonDisable: false,
    );
  }
}
