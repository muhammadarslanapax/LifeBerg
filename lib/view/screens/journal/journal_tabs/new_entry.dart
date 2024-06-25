import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/constant/strings.dart';
import 'package:life_berg/controller/journal_controller/journal_controller.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/choose_color.dart';
import 'package:life_berg/view/widget/custom_bottom_sheet.dart';
import 'package:life_berg/view/widget/dialog_action_button.dart';
import 'package:life_berg/view/widget/image_dialog.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_calender.dart';
import 'package:life_berg/view/widget/my_dialog.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';
import 'package:textfield_tags/textfield_tags.dart';

class NewEntry extends StatefulWidget {
  @override
  State<NewEntry> createState() => _NewEntryState();
}

class _NewEntryState extends State<NewEntry> {

  TextfieldTagsController? _controller;

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
      children: [
        MyTextField(
          hint: 'Title',
        ),
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            MyTextField(
              maxLines: 10,
              hint: 'Reflect away...',
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
          onTap: () => Get.dialog(
            ImageDialog(
              heading: 'Journal Entry Saved!',
              image: Assets.imagesJournalEntrySavedNewImage,
              imageSize: 118.0,
              content: '',
              onOkay: () {
                Get.back();
                final JournalController controller =
                    Get.find<JournalController>();
                controller.tabController.animateTo(
                  1,
                  duration: Duration(
                    milliseconds: 180,
                  ),
                );
              },
            ),
          ),
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
            text: adjustDate,
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
      onTap: () => Navigator.pop(context),
      buttonText: confirm,
      isButtonDisable: false,
    );
  }
}
