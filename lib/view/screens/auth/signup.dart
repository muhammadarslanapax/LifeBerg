import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:life_berg/constant/color.dart';
import 'package:life_berg/constant/sizes_constant.dart';
import 'package:life_berg/controller/auth_controller/signup_controller.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/model/authentocation_models/signup_model.dart';
import 'package:life_berg/view/screens/auth/login.dart';
import 'package:life_berg/view/widget/my_button.dart';
import 'package:life_berg/view/widget/my_text.dart';
import 'package:life_berg/view/widget/my_text_field.dart';
import 'package:life_berg/view/widget/social_login.dart';

import '../../../apis/http_manager.dart';
import '../../../shareprefrences/user_sharedprefrence.dart';
import 'complete_profile/complete_profile.dart';

// ignore: must_be_immutable
class Signup extends StatelessWidget {
  SignupController controller = Get.put(SignupController());

  HttpManager httpManager = HttpManager();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  _signUpUser() async {
    SmartDialog.showLoading(msg: "Please wait..");
    String? token = await FirebaseMessaging.instance.getToken();
    httpManager
        .signUp(
        _firstNameController.text.toString(),
        "",
        _emailController.text.toString(),
        _passwordController.text.toString(),
        token ?? "")
        .then((value) {
      SmartDialog.dismiss();
      if (value.error == null) {
        SignupModel registrationMethod = value.snapshot;
        if (registrationMethod.success == true) {
          Fluttertoast.showToast(msg: registrationMethod.message ?? "");

          SharedPreferencesForUser.getInstance().then((prefs) {

            prefs.setLoggedIn(true);
            prefs.setToken(registrationMethod.token ?? "");
            prefs.setFirstName(registrationMethod.data!.firstName ?? "");
            prefs.setLastName(registrationMethod.data!.lastName ?? "");
            prefs.setEmail(registrationMethod.data!.email ?? "");
            prefs.setUserID(registrationMethod.data!.sId ?? "");


            Get.to(() => CompleteProfile());
          });
        } else {
          SmartDialog.dismiss();
          Fluttertoast.showToast(msg: registrationMethod.message ?? "");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: [
        GestureType.onTap,
        GestureType.onPanUpdateDownDirection,
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollBehavior(),
                child: GlowingOverscrollIndicator(
                  axisDirection: AxisDirection.down,
                  color: kPrimaryColor,
                  child: ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 20,
                    ),
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Image.asset(
                        Assets.imagesLogo,
                        height: 83.34,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MyTextField(
                        hint: 'Full Name',
                        controller: _firstNameController,
                      ),
                      MyTextField(
                        onChanged: (value) => controller.getEmail(value),
                        hint: 'Email Address',
                        controller: _emailController,
                      ),
                      MyTextField(
                        isObSecure: true,
                        hint: 'Password',
                        controller: _passwordController,
                        haveObSecureIcon: true,
                      ),
                      MyTextField(
                        haveObSecureIcon: true,
                        isObSecure: true,
                        controller: _confirmPasswordController,
                        hint: 'Confirm Password',
                      ),
                      MyText(
                        paddingTop: 10,
                        align: TextAlign.center,
                        text:
                            'By creating an account, you agree to our Terms and Conditions',
                        size: 16,
                        paddingBottom: 25,
                      ),
                      Obx(() {
                        return MyButton(
                          isDisable: controller.isDisable.value,
                          text: 'Sign Up',
                          onTap: () {
                            if(_firstNameController.text.toString().isNotEmpty && _emailController.text.toString().isNotEmpty
                            && _passwordController.text.toString().isNotEmpty && _confirmPasswordController.text.toString().isNotEmpty){
                              if(_passwordController.text.toString() == _confirmPasswordController.text.toString()){
                                _signUpUser();
                              }else{
                                Fluttertoast.showToast(msg: "Both Passwords are not same.");
                              }
                            }else{
                              Fluttertoast.showToast(msg: "Please enter all fields.");
                            }
                          },
                        );
                      }),
                      SocialLogin(
                        onGoogle: () {},
                        onFacebook: () {},
                        onApple: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: Platform.isIOS ? IOS_BOTTOM_MARGIN : 12,
              ),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  MyText(
                    text: 'Have an account?',
                    size: 14,
                  ),
                  MyText(
                    onTap: () => Get.offAll(() => Login()),
                    text: ' Sign in here.',
                    color: kTertiaryColor,
                    size: 14,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
