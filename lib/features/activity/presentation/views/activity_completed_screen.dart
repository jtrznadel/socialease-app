import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:lottie/lottie.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';

import 'package:social_ease_app/core/res/media_res.dart';

class ActivityCompletedScreen extends StatelessWidget {
  const ActivityCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Lottie.asset(
              MediaRes.congrats,
              fit: BoxFit.cover,
              repeat: false,
            ),
            // Congratulations Text
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  '🎉',
                  style: TextStyle(
                    fontSize: 96,
                  ),
                ),
                Text(
                  'Congratulations',
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: Fonts.poppins),
                ),
                Text(
                  'You have completed the activity.',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: Fonts.poppins),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: context.height * .35,
                ),
                Text(
                  'Now it\'s all in the hands of the initiative\'s creator. In case of problems, contact the administration.',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontFamily: Fonts.poppins),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
