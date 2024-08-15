import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:life_berg/model/goal/goal.dart';

class ExpandSelectedGoal {
  final CustomDropdown customDropdown;
  Rx<Goal> goal;

  ExpandSelectedGoal(this.customDropdown, this.goal);
}
