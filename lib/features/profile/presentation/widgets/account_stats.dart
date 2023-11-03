import 'package:flutter/material.dart';
import 'package:social_ease_app/core/res/fonts.dart';

class AccountStats extends StatelessWidget {
  const AccountStats({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
        border: Border.all(color: Colors.black, width: 2),
        color: Colors.transparent,
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  '#3',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: Fonts.montserrat),
                ),
                Text(
                  'top rank',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: Fonts.montserrat),
                ),
              ],
            ),
            const VerticalDivider(
              color: Colors.black,
            ),
            Column(
              children: [
                Text(
                  '539',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: Fonts.montserrat),
                ),
                Text(
                  'points',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: Fonts.montserrat),
                ),
              ],
            ),
            const VerticalDivider(
              color: Colors.black,
            ),
            Column(
              children: [
                Text(
                  '38',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: Fonts.montserrat),
                ),
                Text(
                  'activities',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: Fonts.montserrat),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
