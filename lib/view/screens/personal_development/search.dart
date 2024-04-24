import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/screens/personal_development/search_results_tabs/stories.dart';
import 'package:life_berg/view/widget/custom_bottom_sheet.dart';
import 'package:life_berg/view/widget/custom_check_box_tile.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/search_bar.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> with SingleTickerProviderStateMixin {
  bool showResults = false;
  late TabController tabController;
  int currentTab = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {
        currentTab = tabController.index;
      });
    });
  }

  void onChanged(String value) {
    setState(() {
      value.length > 0 ? showResults = true : showResults = false;
    });
  }

  final List<String> tabs = [
    'Articles',
    'Videos',
    'All',
  ];
  final List<Widget> children = [
    SearchResultStories(),
    Container(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Search Results',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SearchBarDAR(
                        onChanged: (value) => onChanged(value),
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
                              height: 320,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    MainHeading(
                                      text: 'Sort by',
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(
                                          3,
                                          (index) {
                                            List<String> _items = [
                                              'Popular',
                                              'Newest',
                                              'Oldest',
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
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: Image.asset(
                          Assets.imagesFilterButtom,
                          height: 17,
                        ),
                      ),
                    ),
                  ],
                ),
                if (showResults)
                  MainHeading(
                    paddingTop: 5,
                    text: 'Search Results',
                  ),
              ],
            ),
          ),
          showResults
              ? Container(
                  margin: EdgeInsets.only(
                    bottom: 10,
                  ),
                  height: 41,
                  child: Center(
                    child: TabBar(
                      controller: tabController,
                      labelPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      indicatorWeight: 5.0,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorPadding: EdgeInsets.zero,
                      indicatorColor: Color(0xffFED189),
                      isScrollable: true,
                      tabs: List.generate(
                        tabs.length,
                        (index) {
                          return MyText(
                            paddingBottom: 4,
                            text: tabs[index],
                            align: TextAlign.start,
                          );
                        },
                      ),
                    ),
                  ),
                )
              : SizedBox(),
          if (showResults)
            Expanded(
              child: TabBarView(
                controller: tabController,
                physics: BouncingScrollPhysics(),
                children: children,
              ),
            ),
        ],
      ),
    );
  }
}
