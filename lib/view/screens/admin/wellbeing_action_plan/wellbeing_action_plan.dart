import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/constant/strings.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/model/action_plan/action_plan.dart';
import 'package:life_berg/utils/instance.dart';
import 'package:life_berg/view/screens/admin/wellbeing_action_plan/wellbing_action_plan_controller.dart';
import 'package:life_berg/view/widget/custom_bottom_sheet.dart';
import 'package:life_berg/view/widget/dialog_action_button.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/menu_item.dart';
import 'package:life_berg/view/widget/my_dialog.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';
import 'package:life_berg/view/widget/toggle_button.dart';
import 'package:textfield_tags/textfield_tags.dart';

import '../../../../utils/toast_utils.dart';
import '../../../widget/my_button.dart';

class WellbeingActionPlan extends StatefulWidget {
  WellbeingActionPlan({Key? key}) : super(key: key);

  @override
  State<WellbeingActionPlan> createState() => _WellbeingActionPlanState();
}

class _WellbeingActionPlanState extends State<WellbeingActionPlan> {
  WellbeingActionPlanController wellbeingActionPlanController =
      Get.put(WellbeingActionPlanController());

  Offset _tapPosition = Offset.zero;

  void _getTapPosition(TapDownDetails tapPosition) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = referenceBox.globalToLocal(tapPosition.globalPosition);
      print(_tapPosition);
    });
  }

  void _showContextMenu(BuildContext context, String type, int index) async {
    final RenderObject? overlay =
        Overlay.of(context)?.context.findRenderObject();
    final result = await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 100, 100),
        Rect.fromLTWH(
          0,
          0,
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
          title: 'Edit item',
          onTap: () {
            Navigator.of(context).pop();
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              elevation: 0,
              isScrollControlled: true,
              builder: (_) {
                var actionPlan = type == "actions"
                    ? wellbeingActionPlanController.actionsList[index]
                    : type == "features"
                        ? wellbeingActionPlanController.features[index]
                        : wellbeingActionPlanController.contacts[index];
                wellbeingActionPlanController.addTextController.text =
                    actionPlan.name ?? "";
                return AddAction(
                  type,
                  wellbeingActionPlanController,
                  actionPlan: actionPlan,
                );
              },
            );
          },
        ),
        menuItem(
          icon: Assets.imagesDeleteThisItem,
          title: 'Delete item',
          borderColor: Colors.transparent,
          onTap: () {
            Navigator.of(context).pop();
            Get.dialog(
              MyDialog(
                icon: Assets.imagesDeleteThisItem,
                heading: 'Delete Item',
                content: 'Are you sure? The selected item will be deleted.',
                haveCustomActionButtons: true,
                customAction: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DialogActionButton(
                      text: 'Undo',
                      onTap: () => Get.back(),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    DialogActionButton(
                      text: 'Delete',
                      textColor: kRedColor,
                      onTap: () {
                        Get.back();
                        wellbeingActionPlanController.deleteActionPlan(
                            type == "actions"
                                ? wellbeingActionPlanController
                                    .actionsList[index].sId!
                                : type == "features"
                                    ? wellbeingActionPlanController
                                        .features[index].sId!
                                    : wellbeingActionPlanController
                                        .contacts[index].sId!,
                            index,
                            type);
                      },
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
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: simpleAppBar(
        haveLeading: false,
        centerTitle: true,
        title: 'Wellbeing Action Plan',
        onBackTap: () => Navigator.pop(context),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
          vertical: 29,
          horizontal: 15,
        ),
        physics: BouncingScrollPhysics(),
        children: [
          Image.asset(
            Assets.imagesIceBag,
            height: 148.27,
          ),
          Obx(() => MainHeading(
            paddingTop: 26.73,
            text: 'Hello ${wellbeingActionPlanController.userName.value}!',
            paddingBottom: 10,
          )),
          MyText(
            text:
                'It is normal to have good days and bad days. Please select some actions, LifeBerg features and people that may help you during those more challenging times in life and I’ll try to nudge you towards them when such times arise! You can also access your wellbeing action plan at anytime by pressing the lifebuoy shortcut on the home page :) ',
            size: 13,
            height: 1.5,
          ),
          Obx(() => wellbeingActionPlanController.isLoadingActionPlan == true
              ? SizedBox(
                  height: 400,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MainHeading(
                      paddingTop: 20,
                      text: 'Actions that help me',
                      paddingBottom: 8,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white,
                        border: Border.all(
                          width: 1.0,
                          color: kBorderColor,
                        ),
                      ),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 16,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: List.generate(
                          wellbeingActionPlanController.actionsList.length + 1,
                          (index) {
                            if (index ==
                                wellbeingActionPlanController
                                    .actionsList.length) {
                              return GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    isScrollControlled: true,
                                    builder: (_) {
                                      return AddAction("actions",
                                          wellbeingActionPlanController);
                                    },
                                  );
                                },
                                child: Image.asset(
                                  Assets.imagesAddIcon,
                                  width: 42,
                                  height: 42,
                                ),
                              );
                            } else {
                              var data = wellbeingActionPlanController
                                  .actionsList[index];
                              return GestureDetector(
                                onTapDown: (position) => {
                                  _getTapPosition(position),
                                },
                                onLongPress: () =>
                                    _showContextMenu(context, "actions", index),
                                child: ToggleButton(
                                  horizontalPadding: 12.0,
                                  onTap: () {
                                    // wellbeingActionPlanController
                                    //     .getActionHelp(index);
                                  },
                                  text: data.name!,
                                  isSelected: false,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    MainHeading(
                      text: 'LifeBerg features that help me',
                      paddingTop: 20,
                      paddingBottom: 8,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: kSecondaryColor,
                        border: Border.all(
                          width: 1.0,
                          color: kBorderColor,
                        ),
                      ),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 16,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: List.generate(
                          wellbeingActionPlanController.features.length + 1,
                          (index) {
                            if (index ==
                                wellbeingActionPlanController.features.length) {
                              return GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    isScrollControlled: true,
                                    builder: (_) {
                                      return AddAction("features",
                                          wellbeingActionPlanController);
                                    },
                                  );
                                },
                                child: Image.asset(
                                  Assets.imagesAddIcon,
                                  width: 42,
                                  height: 42,
                                ),
                              );
                            } else {
                              var data =
                                  wellbeingActionPlanController.features[index];
                              return GestureDetector(
                                onTapDown: (position) => {
                                  _getTapPosition(position),
                                },
                                child: ToggleButton(
                                  onTap: () {},
                                  // onTap: () => wellbeingActionPlanController
                                  //     .getLifeBergFeature(index),
                                  text: data.name ?? "",
                                  isSelected: false,
                                  onLongPress: () => _showContextMenu(
                                      context, "features", index),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    MainHeading(
                      text: 'People I can contact',
                      paddingTop: 20,
                      paddingBottom: 8,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: kSecondaryColor,
                        border: Border.all(
                          width: 1.0,
                          color: kBorderColor,
                        ),
                      ),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 16,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: List.generate(
                          wellbeingActionPlanController.contacts.length + 1,
                          (index) {
                            if (index ==
                                wellbeingActionPlanController.contacts.length) {
                              return GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    isScrollControlled: true,
                                    builder: (_) {
                                      return AddAction("contact",
                                          wellbeingActionPlanController);
                                    },
                                  );
                                },
                                child: Image.asset(
                                  Assets.imagesAddIcon,
                                  width: 42,
                                  height: 42,
                                ),
                              );
                            } else {
                              var data =
                                  wellbeingActionPlanController.contacts[index];
                              return GestureDetector(
                                onTapDown: (position) => {
                                  _getTapPosition(position),
                                },
                                onLongPress: () => _showContextMenu(
                                    context, "contact", index),
                                child: ToggleButton(
                                  onTap: () {},
                                  // onTap: () => wellbeingActionPlanController
                                  //     .getPeopleContact(index),
                                  text: data.name ?? "",
                                  isSelected: false,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                )),
          Padding(
            padding: Platform.isIOS
                ? EdgeInsets.fromLTRB(0, 10, 0, 30)
                : EdgeInsets.fromLTRB(0, 10, 0, 15),
            child: MyButton(
              height: 56,
              radius: 8,
              isDisable: false,
              text: "Submit",
              onTap: (){
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AddAction extends StatefulWidget {
  final String type;
  final WellbeingActionPlanController controller;
  final ActionPlan? actionPlan;

  const AddAction(
    this.type,
    this.controller, {
    this.actionPlan,
    Key? key,
  }) : super(key: key);

  @override
  State<AddAction> createState() => _AddActionState();
}

class _AddActionState extends State<AddAction> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: CustomBottomSheet(
        buttonText: submit,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 6,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainHeading(
                text: widget.type == "actions"
                    ? 'Actions that help me'
                    : widget.type == "contact"
                        ? "People I can contact"
                        : "LifeBerg features that help me",
                paddingBottom: 10,
              ),
              MyTextField(
                fillColor: Colors.white,
                maxLines: 2,
                minLines: 2,
                textInputType: TextInputType.multiline,
                controller: widget.controller.addTextController,
                hint: "Press enter after each item to add more items",
                marginBottom: 0.0,
              ),
            ],
          ),
        ),
        isButtonDisable: false,
        onTap: () {
          if (widget.controller.addTextController.text.isNotEmpty) {
            if (widget.actionPlan != null) {
              widget.controller.updateActionPlan((isUpdated) {
                if (isUpdated) {
                  Navigator.of(context).pop();
                } else {
                  ToastUtils.showToast(someError, color: kRedColor);
                }
              }, widget.actionPlan!.sId ?? "", widget.actionPlan!.category!);
            } else {
              widget.controller.addNewActionPlan((isCreated) {
                if (isCreated) {
                  widget.controller.getUserActionPlans();
                  Get.back();
                } else {
                  ToastUtils.showToast(someError, color: kRedColor);
                }
              }, widget.controller.addTextController.text.toString(),
                  getCategoryId(widget.type));
            }
          } else {
            ToastUtils.showToast("Please enter some text", color: kRedColor);
          }
        },
      ),
    );
  }

  String getCategoryId(String category) {
    switch (category) {
      case "actions":
        return "66910d86e9c4adad06f7bceb";
      case "features":
        return "66911b70c2c80d894db4a270";
      case "contact":
        return "669120eb5af64fef0a6d5f51";
    }
    return "";
  }
}

class AddFeature extends StatefulWidget {
  const AddFeature({
    Key? key,
  }) : super(key: key);

  @override
  State<AddFeature> createState() => _AddFeatureState();
}

class _AddFeatureState extends State<AddFeature> {
  double? _distanceToField;

  TextfieldTagsController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: CustomBottomSheet(
        height: 240,
        buttonText: 'Submit',
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MainHeading(
                text: 'LIfeBerg features that help me',
                paddingBottom: 10,
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
              //   inputfieldBuilder:
              //       (context, tec, fn, error, onChanged, onSubmitted) {
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
              //           hintText: _controller!.hasTags
              //               ? ''
              //               : "Press enter after each item to add more items",
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
            ],
          ),
        ),
        isButtonDisable: false,
        onTap: () => Navigator.pop(context),
      ),
    );
  }
}

class AddContact extends StatefulWidget {
  const AddContact({
    Key? key,
  }) : super(key: key);

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  double? _distanceToField;

  TextfieldTagsController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: CustomBottomSheet(
        height: 240,
        buttonText: 'Submit',
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MainHeading(
                text: 'People I can contact',
                paddingBottom: 10,
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
              //   inputfieldBuilder:
              //       (context, tec, fn, error, onChanged, onSubmitted) {
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
              //           hintText: _controller!.hasTags
              //               ? ''
              //               : "Press enter after each item to add more items",
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
            ],
          ),
        ),
        isButtonDisable: false,
        onTap: () => Navigator.pop(context),
      ),
    );
  }
}
