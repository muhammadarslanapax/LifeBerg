import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/view/widget/choose_color.dart';
import 'package:life_berg/view/widget/custom_bottom_sheet.dart';
import 'package:life_berg/view/widget/main_heading.dart';

import '../../generated/assets.dart';
import 'my_button.dart';

class IconAndColorBottomSheet extends StatefulWidget {

  final Function(Color color, String icon)? onSelect;

  IconAndColorBottomSheet(
      {this.onSelect,
    Key? key,
  }) : super(key: key);

  @override
  State<IconAndColorBottomSheet> createState() =>
      _IconAndColorBottomSheetState();
}

class _IconAndColorBottomSheetState extends State<IconAndColorBottomSheet> {
  // final List<String> icons = [
  //   Assets.imagesFluentSleep,
  //   Assets.imagesIcomoonFreeSleepy,
  //   Assets.imagesMdiBellSleep,
  //   Assets.imagesMdiChatSleepOutline,
  //   Assets.imagesMdiSleepOff,
  //   Assets.imagesNightLightRound,
  //   Assets.imagesNightsStay,
  //   Assets.imagesParkOutlineSleep,
  //   Assets.imagesParkSleep,
  //   Assets.imagesParkSleepOne,
  //   Assets.imagesFluentSleep,
  //   Assets.imagesIcomoonFreeSleepy,
  //   Assets.imagesMdiBellSleep,
  //   Assets.imagesMdiChatSleepOutline,
  //   Assets.imagesMdiSleepOff,
  //   Assets.imagesNightLightRound,
  //   Assets.imagesNightsStay,
  //   Assets.imagesParkOutlineSleep,
  //   Assets.imagesParkSleep,
  //   Assets.imagesParkSleepOne,
  //   Assets.imagesFluentSleep,
  //   Assets.imagesIcomoonFreeSleepy,
  //   Assets.imagesMdiBellSleep,
  //   Assets.imagesMdiChatSleepOutline,
  //   Assets.imagesMdiSleepOff,
  //   Assets.imagesNightLightRound,
  //   Assets.imagesNightsStay,
  //   Assets.imagesParkOutlineSleep,
  //   Assets.imagesParkSleep,
  //   Assets.imagesParkSleepOne,
  //   Assets.imagesParkSleepOne,
  //   Assets.imagesParkSleepOne,
  // ];

  List<String> icons = [
    "abacus.png",
    "abstract.png",
    "ac.png",
    "aircraft.png",
    "airplane.png",
    "apple.png",
    "apricot.png",
    "aquarium.png",
    "armchair.png",
    "armchair_1.png",
    "auto_dozer.png",
    "baby.png",
    "baby_1.png",
    "baby_2.png",
    "backpack.png",
    "bag.png",
    "ball.png",
    "ball_1.png",
    "ball_2.png",
    "ball_3.png",
    "ball_4.png",
    "banana.png",
    "barbecue.png",
    "baseball_1.png",
    "basket.png",
    "basketball.png",
    "bathtub.png",
    "bathtub_1.png",
    "battery.png",
    "bbq.png",
    "bed.png",
    "bed_1.png",
    "bed_2.png",
    "beer.png",
    "bell.png",
    "berries.png",
    "bicycle.png",
    "bird.png",
    "blazer.png",
    "blouse.png",
    "book_1.png",
    "bookmark_folder.png",
    "bottle.png",
    "box.png",
    "bread.png",
    "brush.png",
    "bubbles.png",
    "builder.png",
    "building.png",
    "building_1.png",
    "burger_1.png",
    "bus.png",
    "butterfly.png",
    "cable.png",
    "cactus.png",
    "cake.png",
    "cake_1.png",
    "cake_2.png",
    "calendar_1.png",
    "calendar_2.png",
    "camera_1.png",
    "candy.png",
    "car_1.png",
    "car_2.png",
    "carrot.png",
    "cemetery.png",
    "certificate.png",
    "chat_1.png",
    "chat_2.png",
    "check.png",
    "chef_hat.png",
    "christmas_tree.png",
    "citrus.png",
    "cleaning_brush.png",
    "clock.png",
    "clock_1.png",
    "cloud.png",
    "coffee.png",
    "coffee_1.png",
    "coffee_2.png",
    "coffee_machine.png",
    "coffee_pot.png",
    "coffee_pot_1.png",
    "cold_coffee.png",
    "cold_drink.png",
    "compass.png",
    "construction.png",
    "cosmetics_bottle.png",
    "cosmetics_cream.png",
    "cradle.png",
    "cradle_.png",
    "cube.png",
    "dead_battery.png",
    "desk.png",
    "desk_1.png",
    "desk_2.png",
    "dessert.png",
    "dessert_1.png",
    "detergent.png",
    "diamond.png",
    "dna.png",
    "download_cloud.png",
    "drawer.png",
    "drawer_1.png",
    "dress.png",
    "drill.png",
    "drone.png",
    "drop.png",
    "dropper.png",
    "ducky.png",
    "ear.png",
    "earphones.png",
    "egg.png",
    "egg_1.png",
    "electric_kettle.png",
    "envelope.png",
    "envelope_1.png",
    "envelope_2.png",
    "excavator.png",
    "exclamation.png",
    "eye.png",
    "facebook_2.png",
    "facebook_3.png",
    "family.png",
    "fastener.png",
    "file.png",
    "file_1.png",
    "file_2.png",
    "file_list.png",
    "fir.png",
    "fir_1.png",
    "fishing_1.png",
    "fishing_2.png",
    "flask.png",
    "flower.png",
    "flower_pot.png",
    "folder.png",
    "folder_1.png",
    "food_bowl.png",
    "football_field.png",
    "fork.png",
    "forklift.png",
    "fridge.png",
    "fruits.png",
    "garland.png",
    "gas.png",
    "gift.png",
    "graduation_cap_1.png",
    "graph.png",
    "graph_1.png",
    "graph_2.png",
    "hammer.png",
    "hat.png",
    "heart.png",
    "hearts.png",
    "helmet.png",
    "hockey.png",
    "hospital.png",
    "hot_air_balloon.png",
    "house.png",
    "house_1.png",
    "ice.png",
    "ice_cream.png",
    "infinite.png",
    "instagram_2.png",
    "iron.png",
    "iron_1.png",
    "key.png",
    "kite.png",
    "kiwi.png",
    "knitting_ball.png",
    "lamp.png",
    "laptop.png",
    "law.png",
    "leaf.png",
    "lens.png",
    "linkedin.png",
    "lips.png",
    "lipstick.png",
    "lipstick_1.png",
    "loader.png",
    "lock.png",
    "magnifier.png",
    "map.png",
    "mascara.png",
    "microphone.png",
    "mom.png",
    "money.png",
    "monitor.png",
    "monitor_1.png",
    "nail.png",
    "note.png",
    "notebook.png",
    "notes.png",
    "paint.png",
    "palette.png",
    "palm.png",
    "pan.png",
    "pasta.png",
    "patch.png",
    "pear.png",
    "pen.png",
    "pen_1.png",
    "phone.png",
    "photo.png",
    "pie_chart.png",
    "pill.png",
    "pills.png",
    "pin.png",
    "pizza.png",
    "pizza_1.png",
    "plane.png",
    "plane_landing.png",
    "planet.png",
    "plant.png",
    "pool.png",
    "pot.png",
    "potholder.png",
    "printer.png",
    "purse.png",
    "rake.png",
    "rake_1.png",
    "rattle.png",
    "remote_control.png",
    "road.png",
    "rotation.png",
    "sandwich.png",
    "saturn.png",
    "saucepan.png",
    "scales.png",
    "scissors.png",
    "shopping.png",
    "shopping_cart.png",
    "shoulders.png",
    "shovel.png",
    "shower.png",
    "shower_.png",
    "skateboard.png",
    "skimmer.png",
    "slippers.png",
    "smart_watch.png",
    "smart_watch_1.png",
    "smart_watch_2.png",
    "smartphone.png",
    "snowflake.png",
    "snowman.png",
    "sock.png",
    "sofa.png",
    "sofa_1.png",
    "soup.png",
    "spatula.png",
    "star.png",
    "stepladder.png",
    "stopwatch.png",
    "store.png",
    "stork.png",
    "stork_1.png",
    "suitcase.png",
    "sun.png",
    "sun_1.png",
    "sunbed.png",
    "sunset.png",
    "surprise.png",
    "table.png",
    "table_1.png",
    "table_tennis.png",
    "tag.png",
    "telescope.png",
    "tent.png",
    "test_tubes.png",
    "toaster.png",
    "toaster_1.png",
    "toilet.png",
    "toothbrush.png",
    "toothbrush_1.png",
    "toothpaste.png",
    "tower_crane.png",
    "tractor.png",
    "trailer.png",
    "trash.png",
    "trash_bin.png",
    "tree.png",
    "tree_1.png",
    "tribune.png",
    "tricycle.png",
    "trophy.png",
    "tshirt.png",
    "tv.png",
    "tv_table.png",
    "twitter.png",
    "umbrella.png",
    "users.png",
    "vacuum_cleaner.png",
    "vacuum_cleaner_1.png",
    "volleyball.png",
    "volleyball_1.png",
    "watering.png",
    "waves.png",
    "whatsapp.png",
    "wheelchair.png",
    "wire.png",
    "wrench.png",
    "youtube_2.png",
  ];

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

  int iconIndex = 0;
  int colorIndex = 0;

  Color? color;
  String? icon;

  @override
  void initState() {
    super.initState();
    color = colors[0];
    icon = icons[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.75,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8),
          topLeft: Radius.circular(8),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Image.asset(
                Assets.imagesBottomSheetHandle,
                height: 8,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            MainHeading(
              text: 'Icons',
              paddingBottom: 12,
            ),
            Expanded(
              flex: 7,
              child: GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: BouncingScrollPhysics(),
                itemCount: icons.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisExtent: 35,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      iconIndex = index;
                      icon = icons[iconIndex];
                      if(mounted){
                        setState(() {

                        });
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/goal_icons/${icons[index]}',
                          height: 24,
                          color:
                          iconIndex == index ? kDarkBlueColor : kBlackColor,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MainHeading(
                  paddingTop: 16,
                  text: 'Colour on timeline',
                  paddingBottom: 12,
                ),
                ChooseColor(
                  colors: colors,
                  colorIndex: colorIndex,
                  onTap: (index){
                    if(mounted){
                      setState(() {
                        colorIndex = index;
                        color = colors[colorIndex];
                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: Platform.isIOS
                  ? EdgeInsets.fromLTRB(0, 10, 0, 30)
                  : EdgeInsets.fromLTRB(0, 10, 0, 15),
              child: MyButton(
                height: 56,
                radius: 8,
                isDisable: false,
                text: "Confirm",
                onTap: (){
                  if(color != null &&
                      icon != null && widget.onSelect != null) {
                    widget.onSelect!(color!, icon!);
                  }
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
      /*CustomBottomSheet(
      height: Get.height * 0.75,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MainHeading(
              text: 'Icons',
              paddingBottom: 12,
            ),
            Expanded(
              flex: 7,
              child: GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: BouncingScrollPhysics(),
                itemCount: icons.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisExtent: 35,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      iconIndex = index;
                      icon = icons[iconIndex];
                      if(mounted){
                        setState(() {

                        });
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/goal_icons/${icons[index]}',
                          height: 24,
                          color:
                              iconIndex == index ? kDarkBlueColor : kBlackColor,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MainHeading(
                  paddingTop: 16,
                  text: 'Colour on timeline',
                  paddingBottom: 12,
                ),
                ChooseColor(
                  colors: colors,
                  colorIndex: colorIndex,
                  onTap: (index){
                    if(mounted){
                      setState(() {
                        colorIndex = index;
                        color = colors[colorIndex];
                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
      onTap: () {
        if(color != null &&
        icon != null && widget.onSelect != null) {
          widget.onSelect!(color!, icon!);
        }
        Navigator.of(context).pop();
      },
      isButtonDisable: false,
      buttonText: 'Confirm',
    );*/
  }
}
