import 'package:flutter/material.dart';
import 'package:life_berg/generated/assets.dart';
import 'package:life_berg/view/widget/simple_app_bar.dart';

class Subscription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Subscriptions',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 20,
            ),
            child: Image.asset(
              Assets.imagesComingSoon,
              height: 343,
            ),
          ),
        ],
      ),
    );
  }
}
