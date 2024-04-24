import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/main.dart';
import 'package:life_berg/utils/instance.dart';
import 'package:life_berg/view/screens/personal_development/search.dart';
import 'package:life_berg/view/screens/personal_development/story_detail.dart';
import 'package:life_berg/view/widget/latest_update.dart';
import 'package:life_berg/view/widget/main_heading.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/search_bar.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';
import 'package:life_berg/view/widget/stories_tiles.dart';

class PersonalDevelopment extends StatefulWidget {
  @override
  State<PersonalDevelopment> createState() => _PersonalDevelopmentState();
}

class _PersonalDevelopmentState extends State<PersonalDevelopment>
    with SingleTickerProviderStateMixin {
  bool showResults = false;
  late TabController tabController;
  int currentTab = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
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
    'General',
    'Medical',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Personal Development',
        haveLeading: false,
        centerTitle: true,
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            color: kSecondaryColor,
            padding: EdgeInsets.symmetric(
              vertical: 16,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SearchBarDAR(
                        onTap: () => Get.to(() => Search()),
                      ),
                      // MyText(
                      //   paddingTop: 5,
                      //   paddingBottom: 15,
                      //   text: 'Explore Topics',
                      //   size: 20,
                      //   weight: FontWeight.w500,
                      // ),
                      // GridView.builder(
                      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //     crossAxisCount: 4,
                      //     crossAxisSpacing: 8,
                      //     mainAxisSpacing: 8,
                      //     mainAxisExtent: 101,
                      //   ),
                      //   shrinkWrap: true,
                      //   physics: BouncingScrollPhysics(),
                      //   itemCount: pDevController.exploreTopics.length,
                      //   itemBuilder: (context, index) {
                      //     var data = pDevController.exploreTopics[index];
                      //     return GestureDetector(
                      //       onTap: () => Get.to(
                      //         () => ExploreTopicDetail(
                      //           title: data['title'],
                      //         ),
                      //       ),
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         children: [
                      //           Expanded(
                      //             child: CommonImageView(
                      //               radius: 7.9,
                      //               imagePath: data['img'],
                      //             ),
                      //           ),
                      //           MyText(
                      //             paddingTop: 8,
                      //             text: data['title'],
                      //             size: 12,
                      //           ),
                      //         ],
                      //       ),
                      //     );
                      //   },
                      // ),
                      MainHeading(
                        paddingTop: 8,
                        paddingBottom: 10,
                        text: 'Latest',
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 200,
                  child: PageView.builder(
                    controller: pDevController.latestUpdatePageController,
                    onPageChanged: (index) =>
                        pDevController.onUpdatePageChanged(index),
                    physics: BouncingScrollPhysics(),
                    itemCount: 3,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return LatestUpdate(
                        itemCount: 3,
                        img: dummyImg3,
                        title: 'On the Go Snack Ideas',
                        tag: 'Food',
                        duration: '4 min',
                        onBookmark: () {},
                        onTap: () {},
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: 10,
              top: 8,
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
          ),
          IndexedStack(
            index: currentTab,
            children: [
              general(),
              Container(),
            ],
          ),
          // MyText(
          //   paddingLeft: 15,
          //   paddingTop: 10,
          //   paddingBottom: 15,
          //   text: 'Videos',
          //   size: 20,
          //   weight: FontWeight.w500,
          // ),
          // Container(
          //   height: 200,
          //   child: PageView.builder(
          //     controller: pDevController.videoPageController,
          //     onPageChanged: (index) =>
          //         pDevController.onVideoPageChanged(index),
          //     physics: BouncingScrollPhysics(),
          //     itemCount: 3,
          //     scrollDirection: Axis.horizontal,
          //     itemBuilder: (context, index) {
          //       return VideoThumbnail(
          //         itemCount: 3,
          //         img: dummyImg3,
          //         title: 'Almonds: Do they help?',
          //         subTitle: 'How did people got interested in almonds?',
          //         duration: '4 min',
          //         tags: [
          //           'Food',
          //           'Health & Care',
          //         ],
          //         onPlayTap: () {},
          //         onTap: () {},
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget general() {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 15),
      itemCount: 10,
      itemBuilder: (context, index) {
        return StoriesTiles(
          isVideo: index.isEven,
          img: Assets.imagesMedSchool,
          type: 'Med School',
          title: 'What I have learnt as a new dad in medical school',
          postedTime: '1 day ago',
          duration: '4 min',
          onBookmark: () {},
          onTap: () => Get.to(() => StoryDetail()),
        );
      },
    );
  }
}
