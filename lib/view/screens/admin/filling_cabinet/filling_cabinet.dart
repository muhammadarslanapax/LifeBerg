import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/custom_bottom_sheet.dart';
import 'package:life_berg/view/widget/dialog_action_button.dart';
import 'package:life_berg/view/widget/folder_widget.dart';
import 'package:life_berg/view/widget/icon_and_color_bottom_sheet.dart';
import 'package:life_berg/view/widget/image_dialog.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/menu_item.dart';
import 'package:life_berg/view/widget/my_dialog.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

// ignore: must_be_immutable
class FillingCabinet extends StatefulWidget {
  FillingCabinet({Key? key}) : super(key: key);

  @override
  State<FillingCabinet> createState() => _FillingCabinetState();
}

class _FillingCabinetState extends State<FillingCabinet> {
  List<String> folderTitle = [
    'Registration & Licensing',
    'Employment Forms',
    'Pay Slip',
    'CPD Points',
    'Competency & Certificates',
  ];

  List<String> iconList = [
    Assets.imagesRegistation,
    Assets.imagesEmploymentForms,
    Assets.imagesPaySlip,
    Assets.imagesCpdPoints,
    Assets.imagesPropertyCertificate,
  ];

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
          title: 'Edit folder',
          onTap: () => showModalBottomSheet(
            context: context,
            elevation: 0,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) {
              return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: CustomBottomSheet(
                  height: 244,
                  buttonText: 'Create',
                  isButtonDisable: false,
                  onTap: () => Get.dialog(
                    ImageDialog(
                      imagePaddingLeft: 10.0,
                      heading: 'New Folder Added',
                      image: Assets.imagesNewFolderAddedNewImage,
                      imageSize: 109,
                      content: '',
                      onOkay: () {
                        Get.back();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainHeading(
                          text: 'Edit folder',
                          paddingBottom: 10,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  elevation: 0,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) {
                                    return IconAndColorBottomSheet();
                                  },
                                );
                              },
                              child: Container(
                                height: 47,
                                width: 47,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                    width: 1.0,
                                    color: kBorderColor,
                                  ),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    Assets.imagesPlus,
                                    height: 24,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: MyTextField(
                                hint: 'CPD Points',
                                marginBottom: 0.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        menuItem(
          icon: Assets.imagesDeleteThisItem,
          title: 'Delete Folder',
          borderColor: Colors.transparent,
          onTap: () {
            Get.dialog(
              MyDialog(
                icon: Assets.imagesDeleteThisItem,
                heading: 'Delete Folder',
                content:
                    'Are you sure? The selected folder and all its contents will be deleted.',
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
    return Scaffold(
      backgroundColor: kSecondaryColor,
      appBar: simpleAppBar(
        title: 'Filling Cabinet',
        onBackTap: () => Navigator.pop(context),
      ),
      body: Container(
        height: Get.height,
        width: Get.width,
        child: Stack(
          children: [
            ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(16),
              physics: BouncingScrollPhysics(),
              children: [
                MainHeading(
                  text: 'Upload file',
                  paddingBottom: 8,
                ),
                UploadFile(
                  icon: Assets.imagesUpload,
                  title: 'Upload PDF, PNG, JPG, MP4 \n(max 5MB)',
                ),
                MainHeading(
                  paddingTop: 6,
                  text: 'Folders',
                  paddingBottom: 8,
                ),
                GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: BouncingScrollPhysics(),
                  itemCount: folderTitle.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    mainAxisExtent: 100,
                  ),
                  itemBuilder: (ctx, index) {
                    return GestureDetector(
                      onTapDown: (position) => {
                        _getTapPosition(position),
                      },
                      onLongPress: () => _showContextMenu(context),
                      child: FolderWidget(
                        icon: iconList[index],
                        label: folderTitle[index],
                      ),
                    );
                  },
                ),
              ],
            ),
            Positioned(
              right: 15,
              bottom: 15,
              child: GestureDetector(
                onTap: () => showModalBottomSheet(
                  context: context,
                  elevation: 0,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) {
                    return Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: CustomBottomSheet(
                        height: 244,
                        buttonText: 'Create',
                        isButtonDisable: false,
                        onTap: () => Get.dialog(
                          ImageDialog(
                            imagePaddingLeft: 10.0,
                            heading: 'New Folder Added',
                            image: Assets.imagesNewFolderAddedNewImage,
                            imageSize: 109,
                            content: '',
                            onOkay: () {
                              Get.back();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MainHeading(
                                text: 'Create a new folder',
                                paddingBottom: 10,
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        elevation: 0,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (_) {
                                          return IconAndColorBottomSheet();
                                        },
                                      );
                                    },
                                    child: Container(
                                      height: 47,
                                      width: 47,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        border: Border.all(
                                          width: 1.0,
                                          color: kBorderColor,
                                        ),
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          Assets.imagesPlus,
                                          height: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: MyTextField(
                                      hint: 'Folder Name',
                                      marginBottom: 0.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                child: Image.asset(
                  Assets.imagesAddButton,
                  height: 44,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class UploadFile extends StatelessWidget {
  String? title, icon;
  GestureTapCallback? onTap;

  UploadFile({
    Key? key,
    this.title,
    this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(24),
        margin: EdgeInsets.only(
          bottom: 16,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: kBorderColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Get.dialog(
                  ImageDialog(
                    height: 152.0,
                    heading: 'File Added',
                    imagePaddingLeft: 15.0,
                    imagePaddingBottom: 15.0,
                    image: Assets.imagesFileAddedNew,
                    imageSize: 95,
                    content: '',
                    onOkay: () => Get.back(),
                  ),
                );
              },
              child: Image.asset(
                icon!,
                height: 32,
                color: kTertiaryColor,
              ),
            ),
            MyText(
              paddingTop: 8,
              text: title,
              align: TextAlign.center,
              height: 1.7,
              weight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}
