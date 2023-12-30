import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:social_ease_app/core/common/widgets/stats_element.dart';
import 'package:social_ease_app/core/res/media_res.dart';

class UserOfTheMonth extends StatelessWidget {
  const UserOfTheMonth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(MediaRes.defaultAvatarImage),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Jakub Trznadel",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  StatsElement(
                    color: Colors.yellow,
                    icon: Icons.star,
                    text: '1',
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  StatsElement(
                    color: Colors.yellow,
                    icon: Icons.star,
                    text: '1',
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  StatsElement(
                    color: Colors.yellow,
                    icon: Icons.star,
                    text: '1',
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
