import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/model/icon/icon_model.dart';
import 'package:life_berg/view/widget/choose_color.dart';
import 'package:life_berg/view/widget/custom_bottom_sheet.dart';
import 'package:life_berg/view/widget/main_heading.dart';

import '../../generated/assets.dart';
import 'my_button.dart';

class IconAndColorBottomSheet extends StatefulWidget {
  final Function(String icon)? onSelect;

  IconAndColorBottomSheet({
    this.onSelect,
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

  List<IconModel> iconList = [];

  // List<String> icons = [
  //   "abacus.png",
  //   "abstract.png",
  //   "ac.png",
  //   "aircraft.png",
  //   "airplane.png",
  //   "apple.png",
  //   "apricot.png",
  //   "aquarium.png",
  //   "armchair.png",
  //   "armchair_1.png",
  //   "auto_dozer.png",
  //   "baby.png",
  //   "baby_1.png",
  //   "baby_2.png",
  //   "backpack.png",
  //   "bag.png",
  //   "ball.png",
  //   "ball_1.png",
  //   "ball_2.png",
  //   "ball_3.png",
  //   "ball_4.png",
  //   "banana.png",
  //   "barbecue.png",
  //   "baseball_1.png",
  //   "basket.png",
  //   "basketball.png",
  //   "bathtub.png",
  //   "bathtub_1.png",
  //   "battery.png",
  //   "bbq.png",
  //   "bed.png",
  //   "bed_1.png",
  //   "bed_2.png",
  //   "beer.png",
  //   "bell.png",
  //   "berries.png",
  //   "bicycle.png",
  //   "bird.png",
  //   "blazer.png",
  //   "blouse.png",
  //   "book_1.png",
  //   "bookmark_folder.png",
  //   "bottle.png",
  //   "box.png",
  //   "bread.png",
  //   "brush.png",
  //   "bubbles.png",
  //   "builder.png",
  //   "building.png",
  //   "building_1.png",
  //   "burger_1.png",
  //   "bus.png",
  //   "butterfly.png",
  //   "cable.png",
  //   "cactus.png",
  //   "cake.png",
  //   "cake_1.png",
  //   "cake_2.png",
  //   "calendar_1.png",
  //   "calendar_2.png",
  //   "camera_1.png",
  //   "candy.png",
  //   "car_1.png",
  //   "car_2.png",
  //   "carrot.png",
  //   "cemetery.png",
  //   "certificate.png",
  //   "chat_1.png",
  //   "chat_2.png",
  //   "check.png",
  //   "chef_hat.png",
  //   "christmas_tree.png",
  //   "citrus.png",
  //   "cleaning_brush.png",
  //   "clock.png",
  //   "clock_1.png",
  //   "cloud.png",
  //   "coffee.png",
  //   "coffee_1.png",
  //   "coffee_2.png",
  //   "coffee_machine.png",
  //   "coffee_pot.png",
  //   "coffee_pot_1.png",
  //   "cold_coffee.png",
  //   "cold_drink.png",
  //   "compass.png",
  //   "construction.png",
  //   "cosmetics_bottle.png",
  //   "cosmetics_cream.png",
  //   "cradle.png",
  //   "cradle_.png",
  //   "cube.png",
  //   "dead_battery.png",
  //   "desk.png",
  //   "desk_1.png",
  //   "desk_2.png",
  //   "dessert.png",
  //   "dessert_1.png",
  //   "detergent.png",
  //   "diamond.png",
  //   "dna.png",
  //   "download_cloud.png",
  //   "drawer.png",
  //   "drawer_1.png",
  //   "dress.png",
  //   "drill.png",
  //   "drone.png",
  //   "drop.png",
  //   "dropper.png",
  //   "ducky.png",
  //   "ear.png",
  //   "earphones.png",
  //   "egg.png",
  //   "egg_1.png",
  //   "electric_kettle.png",
  //   "envelope.png",
  //   "envelope_1.png",
  //   "envelope_2.png",
  //   "excavator.png",
  //   "exclamation.png",
  //   "eye.png",
  //   "facebook_2.png",
  //   "facebook_3.png",
  //   "family.png",
  //   "fastener.png",
  //   "file.png",
  //   "file_1.png",
  //   "file_2.png",
  //   "file_list.png",
  //   "fir.png",
  //   "fir_1.png",
  //   "fishing_1.png",
  //   "fishing_2.png",
  //   "flask.png",
  //   "flower.png",
  //   "flower_pot.png",
  //   "folder.png",
  //   "folder_1.png",
  //   "food_bowl.png",
  //   "football_field.png",
  //   "fork.png",
  //   "forklift.png",
  //   "fridge.png",
  //   "fruits.png",
  //   "garland.png",
  //   "gas.png",
  //   "gift.png",
  //   "graduation_cap_1.png",
  //   "graph.png",
  //   "graph_1.png",
  //   "graph_2.png",
  //   "hammer.png",
  //   "hat.png",
  //   "heart.png",
  //   "hearts.png",
  //   "helmet.png",
  //   "hockey.png",
  //   "hospital.png",
  //   "hot_air_balloon.png",
  //   "house.png",
  //   "house_1.png",
  //   "ice.png",
  //   "ice_cream.png",
  //   "infinite.png",
  //   "instagram_2.png",
  //   "iron.png",
  //   "iron_1.png",
  //   "key.png",
  //   "kite.png",
  //   "kiwi.png",
  //   "knitting_ball.png",
  //   "lamp.png",
  //   "laptop.png",
  //   "law.png",
  //   "leaf.png",
  //   "lens.png",
  //   "linkedin.png",
  //   "lips.png",
  //   "lipstick.png",
  //   "lipstick_1.png",
  //   "loader.png",
  //   "lock.png",
  //   "magnifier.png",
  //   "map.png",
  //   "mascara.png",
  //   "microphone.png",
  //   "mom.png",
  //   "money.png",
  //   "monitor.png",
  //   "monitor_1.png",
  //   "nail.png",
  //   "note.png",
  //   "notebook.png",
  //   "notes.png",
  //   "paint.png",
  //   "palette.png",
  //   "palm.png",
  //   "pan.png",
  //   "pasta.png",
  //   "patch.png",
  //   "pear.png",
  //   "pen.png",
  //   "pen_1.png",
  //   "phone.png",
  //   "photo.png",
  //   "pie_chart.png",
  //   "pill.png",
  //   "pills.png",
  //   "pin.png",
  //   "pizza.png",
  //   "pizza_1.png",
  //   "plane.png",
  //   "plane_landing.png",
  //   "planet.png",
  //   "plant.png",
  //   "pool.png",
  //   "pot.png",
  //   "potholder.png",
  //   "printer.png",
  //   "purse.png",
  //   "rake.png",
  //   "rake_1.png",
  //   "rattle.png",
  //   "remote_control.png",
  //   "road.png",
  //   "rotation.png",
  //   "sandwich.png",
  //   "saturn.png",
  //   "saucepan.png",
  //   "scales.png",
  //   "scissors.png",
  //   "shopping.png",
  //   "shopping_cart.png",
  //   "shoulders.png",
  //   "shovel.png",
  //   "shower.png",
  //   "shower_.png",
  //   "skateboard.png",
  //   "skimmer.png",
  //   "slippers.png",
  //   "smart_watch.png",
  //   "smart_watch_1.png",
  //   "smart_watch_2.png",
  //   "smartphone.png",
  //   "snowflake.png",
  //   "snowman.png",
  //   "sock.png",
  //   "sofa.png",
  //   "sofa_1.png",
  //   "soup.png",
  //   "spatula.png",
  //   "star.png",
  //   "stepladder.png",
  //   "stopwatch.png",
  //   "store.png",
  //   "stork.png",
  //   "stork_1.png",
  //   "suitcase.png",
  //   "sun.png",
  //   "sun_1.png",
  //   "sunbed.png",
  //   "sunset.png",
  //   "surprise.png",
  //   "table.png",
  //   "table_1.png",
  //   "table_tennis.png",
  //   "tag.png",
  //   "telescope.png",
  //   "tent.png",
  //   "test_tubes.png",
  //   "toaster.png",
  //   "toaster_1.png",
  //   "toilet.png",
  //   "toothbrush.png",
  //   "toothbrush_1.png",
  //   "toothpaste.png",
  //   "tower_crane.png",
  //   "tractor.png",
  //   "trailer.png",
  //   "trash.png",
  //   "trash_bin.png",
  //   "tree.png",
  //   "tree_1.png",
  //   "tribune.png",
  //   "tricycle.png",
  //   "trophy.png",
  //   "tshirt.png",
  //   "tv.png",
  //   "tv_table.png",
  //   "twitter.png",
  //   "umbrella.png",
  //   "users.png",
  //   "vacuum_cleaner.png",
  //   "vacuum_cleaner_1.png",
  //   "volleyball.png",
  //   "volleyball_1.png",
  //   "watering.png",
  //   "waves.png",
  //   "whatsapp.png",
  //   "wheelchair.png",
  //   "wire.png",
  //   "wrench.png",
  //   "youtube_2.png",
  // ];

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

  // int iconIndex = 0;
  int colorIndex = 0;

  // Color? color;
  String? icon;

  @override
  void initState() {
    super.initState();
    setIconModelList();
    // color = colors[0];

    // icon = icons[0];
  }

  setIconModelList() {
    List<String> activitiesIcons = [];
    activitiesIcons.add("wrench.png");
    activitiesIcons.add("watering.png");
    activitiesIcons.add("vacuum_cleaner_1.png");
    activitiesIcons.add("trash_bin.png");
    activitiesIcons.add("toothbrush.png");
    activitiesIcons.add("toilet.png");
    activitiesIcons.add("surprise.png");
    activitiesIcons.add("shower.png");
    activitiesIcons.add("shopping_cart.png");
    activitiesIcons.add("rotation.png");
    activitiesIcons.add("potholder.png");
    // activitiesIcons.add("plane.png");
    activitiesIcons.add("palette.png");
    activitiesIcons.add("pan.png");
    activitiesIcons.add("bible.png");
    activitiesIcons.add("board_game.png");
    activitiesIcons.add("chat.png");
    activitiesIcons.add("diary.png");
    activitiesIcons.add("guitar.png");
    activitiesIcons.add("kindness_1.png");
    activitiesIcons.add("kindness.png");
    activitiesIcons.add("language.png");
    activitiesIcons.add("piano.png");
    activitiesIcons.add("pray.png");
    activitiesIcons.add("note.png");
    activitiesIcons.add("monitor.png");
    activitiesIcons.add("microphone.png");
    activitiesIcons.add("knitting_ball.png");
    activitiesIcons.add("iron.png");
    activitiesIcons.add("fork.png");
    activitiesIcons.add("family.png");
    activitiesIcons.add("eye.png");
    activitiesIcons.add("ear.png");
    activitiesIcons.add("drone.png");
    activitiesIcons.add("cradle.png");
    activitiesIcons.add("cleaning_brush.png");
    activitiesIcons.add("car_2.png");
    activitiesIcons.add("camera_1.png");
    activitiesIcons.add("bubbles.png");
    activitiesIcons.add("bottle.png");
    activitiesIcons.add("book_1.png");
    activitiesIcons.add("bed.png");
    activitiesIcons.add("bathtub.png");
    activitiesIcons.add("baby.png");
    activitiesIcons.add("baby_2.png");
    activitiesIcons.add("airplane.png");
    iconList.add(IconModel("Activities", activitiesIcons));
    List<String> vocationIcons = [];
    vocationIcons.add("users.png");
    vocationIcons.add("tower_crane.png");
    vocationIcons.add("test_tubes.png");
    vocationIcons.add("telescope.png");
    vocationIcons.add("suitcase.png");
    vocationIcons.add("smartphone.png");
    vocationIcons.add("phone.png");
    vocationIcons.add("pen.png");
    vocationIcons.add("note.png");
    vocationIcons.add("magnifier.png");
    vocationIcons.add("lens.png");
    vocationIcons.add("law.png");
    vocationIcons.add("laptop.png");
    vocationIcons.add("hospital.png");
    vocationIcons.add("hammer.png");
    vocationIcons.add("graph.png");
    vocationIcons.add("graph_1.png");
    vocationIcons.add("goal.png");
    vocationIcons.add("health_1.png");
    // vocationIcons.add("health.png");
    vocationIcons.add("lecture.png");
    vocationIcons.add("medical_1.png");
    vocationIcons.add("medical_equipment.png");
    vocationIcons.add("medical.png");
    // vocationIcons.add("meeting_room.png");
    vocationIcons.add("user-feedback.png");
    vocationIcons.add("car_1.png");
    vocationIcons.add("graduation_cap_1.png");
    vocationIcons.add("folder.png");
    vocationIcons.add("file_list.png");
    vocationIcons.add("envelope_1.png");
    vocationIcons.add("drawer_1.png");
    vocationIcons.add("desk.png");
    vocationIcons.add("clock.png");
    vocationIcons.add("chef_hat.png");
    vocationIcons.add("check.png");
    vocationIcons.add("certificate.png");
    vocationIcons.add("bus.png");
    vocationIcons.add("auto_dozer.png");
    iconList.add(IconModel("Vocation", vocationIcons));
    List<String> foodDrinkIcons = [];
    foodDrinkIcons.add("toaster.png");
    foodDrinkIcons.add("soup.png");
    foodDrinkIcons.add("sandwich.png");
    foodDrinkIcons.add("pizza.png");
    foodDrinkIcons.add("pizza_1.png");
    foodDrinkIcons.add("pear.png");
    foodDrinkIcons.add("pasta.png");
    foodDrinkIcons.add("dessert.png");
    foodDrinkIcons.add("cold_drink.png");
    foodDrinkIcons.add("coffee_2.png");
    foodDrinkIcons.add("coffee_pot.png");
    foodDrinkIcons.add("citrus.png");
    foodDrinkIcons.add("carrot.png");
    foodDrinkIcons.add("candy.png");
    foodDrinkIcons.add("cake_2.png");
    foodDrinkIcons.add("cake_1.png");
    foodDrinkIcons.add("bread.png");
    foodDrinkIcons.add("berries.png");
    foodDrinkIcons.add("burger_1.png");
    foodDrinkIcons.add("bbq.png");
    foodDrinkIcons.add("banana.png");
    foodDrinkIcons.add("apple.png");
    iconList.add(IconModel("Food & drink", foodDrinkIcons));
    List<String> itemIcons = [];
    itemIcons.add("wheelchair.png");
    itemIcons.add("toothpaste.png");
    itemIcons.add("sofa.png");
    itemIcons.add("sock.png");
    itemIcons.add("smart_watch_1.png");
    itemIcons.add("skimmer.png");
    itemIcons.add("shoulders.png");
    itemIcons.add("scales.png");
    itemIcons.add("saucepan.png");
    itemIcons.add("pills.png");
    itemIcons.add("money.png");
    itemIcons.add("lipstick.png");
    itemIcons.add("house_1.png");
    itemIcons.add("hat.png");
    itemIcons.add("gift.png");
    itemIcons.add("garland.png");
    itemIcons.add("dress.png");
    itemIcons.add("diamond.png");
    itemIcons.add("cosmetics_cream.png");
    itemIcons.add("christmas_tree.png");
    itemIcons.add("blouse.png");
    itemIcons.add("blazer.png");
    itemIcons.add("bag.png");
    itemIcons.add("baby_1.png");
    iconList.add(IconModel("Items", itemIcons));
    List<String> sportIcons = [];
    sportIcons.add("waves.png");
    sportIcons.add("volleyball_1.png");
    sportIcons.add("volleyball.png");
    sportIcons.add("trophy.png");
    sportIcons.add("table_tennis.png");
    sportIcons.add("run.png");
    sportIcons.add("stretch.png");
    sportIcons.add("walk_directions.png");
    sportIcons.add("sport_goal.png");
    sportIcons.add("pool.png");
    sportIcons.add("ice_cream.png");
    sportIcons.add("hockey.png");
    sportIcons.add("helmet.png");
    sportIcons.add("bicycle.png");
    sportIcons.add("basketball.png");
    sportIcons.add("baseball_1.png");
    sportIcons.add("football.png");
    sportIcons.add("sock_ball.png");
    sportIcons.add("football.png");
    sportIcons.add("ball.png");
    sportIcons.add("ball_2.png");
    sportIcons.add("ball_1.png");
    iconList.add(IconModel("Sports", sportIcons));
    List<String> animalIcons = [];
    animalIcons.add("food_bowl.png");
    animalIcons.add("aquarium.png");
    animalIcons.add("cat.png");
    animalIcons.add("chicken.png");
    animalIcons.add("cow.png");
    animalIcons.add("dog.png");
    animalIcons.add("horse.png");
    animalIcons.add("rabbit.png");
    animalIcons.add("butterfly.png");
    animalIcons.add("bird.png");
    iconList.add(IconModel("Animals", animalIcons));
    List<String> outdoorIcons = [];
    outdoorIcons.add("tree.png");
    outdoorIcons.add("trailer.png");
    outdoorIcons.add("sunset.png");
    outdoorIcons.add("sunbed.png");
    outdoorIcons.add("sun.png");
    outdoorIcons.add("sun_1.png");
    outdoorIcons.add("snowman.png");
    outdoorIcons.add("snowflake.png");
    outdoorIcons.add("saturn.png");
    outdoorIcons.add("road.png");
    outdoorIcons.add("palm.png");
    outdoorIcons.add("map.png");
    outdoorIcons.add("kite.png");
    outdoorIcons.add("flower.png");
    outdoorIcons.add("flower_pot.png");
    outdoorIcons.add("fishing_2.png");
    outdoorIcons.add("compass.png");
    outdoorIcons.add("cemetery.png");
    outdoorIcons.add("building_1.png");
    iconList.add(IconModel("Outdoor", outdoorIcons));
    List<String> shapeIcons = [];
    shapeIcons.add("youtube_2.png");
    shapeIcons.add("whatsapp.png");
    shapeIcons.add("twitter.png");
    shapeIcons.add("tiktok.png");
    shapeIcons.add("star.png");
    shapeIcons.add("linkedin.png");
    shapeIcons.add("instagram_2.png");
    shapeIcons.add("heart.png");
    shapeIcons.add("growth.png");
    shapeIcons.add("facebook_2.png");
    shapeIcons.add("facebook_3.png");
    shapeIcons.add("exclamation.png");
    shapeIcons.add("christianity.png");
    iconList.add(IconModel("Shapes", shapeIcons));
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
            Expanded(
              flex: 7,
              child: ListView.builder(
                itemBuilder: (BuildContext ctx, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainHeading(
                          text: iconList[index].category,
                          paddingBottom: 12,
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: BouncingScrollPhysics(),
                          itemCount: iconList[index].icons.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            mainAxisExtent: 35,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 16,
                          ),
                          itemBuilder: (context, iconInd) {
                            return GestureDetector(
                              onTap: () {
                                icon = iconList[index].icons[iconInd];
                                if (mounted) {
                                  setState(() {});
                                }
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/goal_icons/${iconList[index].icons[iconInd]}',
                                    height: 24,
                                    color:
                                        icon == iconList[index].icons[iconInd]
                                            ? kDarkBlueColor
                                            : kBlackColor,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
                itemCount: iconList.length,
              ),
            ),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.stretch,
            //   children: [
            //     MainHeading(
            //       paddingTop: 16,
            //       text: 'Colour on timeline',
            //       paddingBottom: 12,
            //     ),
            //     ChooseColor(
            //       colors: colors,
            //       colorIndex: colorIndex,
            //       onTap: (index){
            //         if(mounted){
            //           setState(() {
            //             colorIndex = index;
            //             color = colors[colorIndex];
            //           });
            //         }
            //       },
            //     ),
            //   ],
            // ),
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
                onTap: () {
                  if (icon != null && widget.onSelect != null) {
                    widget.onSelect!(icon!);
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
