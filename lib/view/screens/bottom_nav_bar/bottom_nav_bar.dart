import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/screens/admin/main_life_administration.dart';
import 'package:life_berg/view/screens/home/home.dart';
import 'package:life_berg/view/screens/journal/journal.dart';
import 'package:life_berg/view/screens/personal_development/personal_development.dart';
import 'package:life_berg/view/screens/personal_statistics/personal_statistics.dart';

import '../../../utils/pref_utils.dart';

final GlobalKey<BottomNavBarState> bottomNavBarKey = GlobalKey<BottomNavBarState>();

class BottomNavBar extends StatefulWidget {
  BottomNavBar({this.currentIndex = 0, this.currentRoute = '/home', Key? key}) : super(key: key);

  int? currentIndex;
  String? currentRoute;

  @override
  State<BottomNavBar> createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  List<String> items = [
    Assets.imagesB1,
    Assets.imagesB2,
    Assets.imagesB3,
    Assets.imagesB4,
    Assets.imagesB5,
  ];

  final List<Widget> screens = [
    Home(),
    Journal(),
    MainLifeAdministration(),
    PersonalDevelopment(),
    PersonalStatistics(),
  ];

  List<String> _pageRoutes = [
    '/home',
    '/journal',
    '/main_life_administration',
    '/personal_development',
    '/personal_statistics',
  ];

  Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    '/home': GlobalKey<NavigatorState>(),
    '/journal': GlobalKey<NavigatorState>(),
    '/main_life_administration': GlobalKey<NavigatorState>(),
    '/personal_development': GlobalKey<NavigatorState>(),
    '/personal_statistics': GlobalKey<NavigatorState>(),
  };

  void selectTab(int index) {
    final page = _pageRoutes[index];
    setState(() {
      widget.currentRoute = page;
      widget.currentIndex = index;
    });
    // Clear stacks for all pages except the selected one
    _navigatorKeys.forEach((route, key) {
      if (route != widget.currentRoute) {
        key.currentState!.popUntil((route) => route.isFirst);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (PrefUtils().lastSavedDate.isEmpty) {
      PrefUtils().lastSavedDate = DateTime.now().toIso8601String();
    }
  }

  void getCurrentScreens(String currentPage, int index) {
    if (currentPage == widget.currentRoute) {
      // Clear the stack for the current page navigator
      _navigatorKeys[currentPage]!.currentState!.popUntil(
            (route) => route.isFirst,
          );
    } else {
      setState(() {
        widget.currentRoute = _pageRoutes[index];
        widget.currentIndex = index;
        // Clear stacks for all other pages
        _navigatorKeys.forEach((route, key) {
          if (route != widget.currentRoute) {
            key.currentState!.popUntil((route) => route.isFirst);
          }
        });
      });
    }
  }

  Widget _buildOffStageNavigator(String page) {
    return Offstage(
      offstage: widget.currentRoute != page,
      child: PageNavigator(
        navigatorKey: _navigatorKeys[page]!,
        page: page,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var isIos = Theme.of(context).platform;
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentIndex = await _navigatorKeys[widget.currentRoute]!.currentState!.maybePop();

        if (isFirstRouteInCurrentIndex) {
          getCurrentScreens(_pageRoutes[0], 0); // Navigate to home
          return false;
        }
        return isFirstRouteInCurrentIndex;
      },
      child: Scaffold(
        body: Stack(
          children: [
            _buildOffStageNavigator('/home'),
            _buildOffStageNavigator('/journal'),
            _buildOffStageNavigator('/main_life_administration'),
            _buildOffStageNavigator('/personal_development'),
            _buildOffStageNavigator('/personal_statistics'),
          ],
        ),
        bottomNavigationBar: _bottomNavBar(isIos),
      ),
    );
  }

  Widget _bottomNavBar(TargetPlatform isIos) {
    return Container(
      height: isIos == TargetPlatform.iOS ? null : 70,
      color: kSeoulColor.withOpacity(0.94),
      child: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        onTap: (index) => getCurrentScreens(_pageRoutes[index], index),
        type: BottomNavigationBarType.fixed,
        currentIndex: widget.currentIndex!,
        showSelectedLabels: false,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        showUnselectedLabels: false,
        selectedItemColor: kTertiaryColor,
        items: List.generate(
          items.length,
          (index) {
            return BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage(
                  items[index],
                ),
                size: 24,
              ),
              label: '',
            );
          },
        ),
      ),
    );
  }
}

class PageNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final String page;

  const PageNavigator({
    super.key,
    required this.navigatorKey,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    Widget? child;

    if (page == '/home')
      child = Home();
    else if (page == '/journal')
      child = Journal();
    else if (page == '/main_life_administration')
      child = MainLifeAdministration();
    else if (page == '/personal_development')
      child = PersonalDevelopment();
    else if (page == '/personal_statistics') child = PersonalStatistics();
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (_) => child!);
      },
    );
  }
}
