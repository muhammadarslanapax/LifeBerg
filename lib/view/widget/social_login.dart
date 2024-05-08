import 'dart:io';

import 'package:flutter/material.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/icon_button.dart';

class SocialLogin extends StatelessWidget {
  const SocialLogin({
    Key? key,
    required this.onGoogle,
    required this.onFacebook,
    required this.onApple,
  }) : super(key: key);

  final VoidCallback onGoogle, onFacebook, onApple;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MyIconButton(
          onTap: onGoogle,
          icon: Assets.imagesGoogle,
          text: 'Sign in with Google',
        ),
        SizedBox(
          height: 10,
        ),
        MyIconButton(
          onTap:onFacebook,
          icon: Assets.imagesFacebook,
          text: 'Sign in with Facebook',
        ),
        SizedBox(
          height: 10,
        ),
        Platform.isAndroid ?
            Container() :
        MyIconButton(
          onTap: onApple,
          icon: Assets.imagesApple,
          text: 'Sign in with Apple',
        ),
        SizedBox(
          height: 25,
        ),
      ],
    );
  }
}