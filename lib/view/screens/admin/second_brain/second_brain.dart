import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/screens/admin/second_brain/second_brain_tabs/admin.dart';
import 'package:life_berg/view/screens/admin/second_brain/second_brain_tabs/notes.dart';
import 'package:life_berg/view/screens/admin/second_brain/second_brain_tabs/todo.dart';
import 'package:life_berg/view/widget/add_new_tab.dart';
import 'package:life_berg/view/widget/create_new_item.dart';
import 'package:life_berg/view/widget/dialog_action_button.dart';
import 'package:life_berg/view/widget/menu_item.dart';
import 'package:life_berg/view/widget/my_dialog.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

class SecondBrain extends StatefulWidget {
  @override
  State<SecondBrain> createState() => _SecondBrainState();
}

class _SecondBrainState extends State<SecondBrain> with SingleTickerProviderStateMixin{
  late TabController tabController;
  int currentTab = 0;
  List<String> tabs = [
    'Notes',
    'To-Do',
    'Admin',
  ];

  List<Widget> tabViews = [
    Notes(),
    Todo(),
    Admin(),
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
          title: 'Edit Tab',
          onTap: () {},
        ),
        menuItem(
          icon: Assets.imagesDeleteThisItem,
          title: 'Delete Tab',
          borderColor: Colors.transparent,
          onTap: () {
            Get.dialog(
              MyDialog(
                icon: Assets.imagesDeleteThisItem,
                heading: 'Delete Tab',
                content:
                    'Are you sure? The selected tab and all its associated items will be deleted. ',
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
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(() {
      setState(() {
        currentTab = tabController.index;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      appBar: simpleAppBar(
        title: 'Second Brain',
        onBackTap: () => Navigator.pop(context),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 41,
                    child: Center(
                      child: TabBar(
                        controller: tabController,
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: kDayStepColor,
                        indicatorWeight: 4,
                        labelPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        tabs: List<Tab>.generate(
                          tabs.length,
                          (index) => Tab(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  tabController.animateTo(index);
                                  currentTab = index;
                                });
                              },
                              onTapDown: (position) => {
                                _getTapPosition(position),
                              },
                              onLongPress: () => _showContextMenu(context),
                              child: Container(
                                color: Colors.transparent,
                                child: MyText(
                                  text: tabs[index],
                                  size: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (_) {
                        return AddNewTab();
                      },
                    );
                  },
                  child: Image.asset(
                    Assets.imagesPlusIcon,
                    height: 20,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Expanded(
            child: Stack(
              children: [
                TabBarView(
                  controller:tabController,
                  physics: BouncingScrollPhysics(),
                  children: tabViews,
                ),
                Positioned(
                  right: 15,
                  bottom: 15,
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (_) {
                          return CreateNewItem();
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
            ),
          ),
        ],
      ),
    );
  }
}
