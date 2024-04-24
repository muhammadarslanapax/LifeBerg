import 'package:get/get.dart';
import 'package:life_berg/model/setup_goal_model/setup_goal_model.dart';

class WellbeingActionPlanController extends GetxController {
  static WellbeingActionPlanController instance =
      Get.find<WellbeingActionPlanController>();

  //
  // Rx<Offset> _tapPosition = Offset.zero.obs;
  //
  // void getTapPosition(TapDownDetails tapPosition, BuildContext context) {
  //   final RenderBox referenceBox = context.findRenderObject() as RenderBox;
  //
  //   _tapPosition.value = referenceBox.globalToLocal(
  //       tapPosition.globalPosition);
  // }

  final List<ToggleButtonModel> actionHelpList = [
    ToggleButtonModel(
      text: 'Pray',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Go for a run',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Spend time in nature',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Debrief with others',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Read',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: '',
      isSelected: false.obs,
    ),
  ];

  final List<ToggleButtonModel> selectedActionHelp = [];

  void getActionHelp(int index) {
    var data = actionHelpList[index];
    data.isSelected.value = !data.isSelected.value;
    if (data.isSelected.value == true) {
      selectedActionHelp.add(
        ToggleButtonModel(
          text: data.text,
          isSelected: true.obs,
        ),
      );
    } else {
      selectedActionHelp.removeWhere((element) => element.text == data.text);
    }
  }

  final List<ToggleButtonModel> lifeBergFeatureList = [
    ToggleButtonModel(
      text: 'Gratitude Journal',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Make a Plan: Life Admin',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Adjust Goals',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Add wellbeing goal',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Add wellbeing goal',
      isSelected: false.obs,
    ),
  ];

  final List<ToggleButtonModel> selectedLifeBergFeature = [];

  void getLifeBergFeature(int index) {
    var data = lifeBergFeatureList[index];
    data.isSelected.value = !data.isSelected.value;
    if (data.isSelected.value == true) {
      selectedLifeBergFeature.add(
        ToggleButtonModel(
          text: data.text,
          isSelected: true.obs,
        ),
      );
    } else {
      selectedLifeBergFeature
          .removeWhere((element) => element.text == data.text);
    }
  }

  final List<ToggleButtonModel> peopleContactList = [
    ToggleButtonModel(
      text: 'Andrea',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Ming',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Joo Lin',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Haris',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Jasmine',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Esther',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Guy',
      isSelected: false.obs,
    ),
    ToggleButtonModel(
      text: 'Robert',
      isSelected: false.obs,
    ),
  ];

  final List<ToggleButtonModel> selectedPeopleContact = [];

  void getPeopleContact(int index) {
    var data = peopleContactList[index];
    data.isSelected.value = !data.isSelected.value;
    if (data.isSelected.value == true) {
      selectedPeopleContact.add(
        ToggleButtonModel(
          text: data.text,
          isSelected: true.obs,
        ),
      );
    } else {
      selectedPeopleContact.removeWhere((element) => element.text == data.text);
    }
  }
}
