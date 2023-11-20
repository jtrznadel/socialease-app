import 'package:flutter/material.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';

class ExploreMap extends StatelessWidget {
  const ExploreMap({super.key, required this.activities});

  final List<Activity> activities;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width *
            0.9, // Dostosuj szerokość do własnych potrzeb
        height: MediaQuery.of(context).size.height *
            0.8, // Dostosuj wysokość do własnych potrzeb
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0), // Zaokrąglone brzegi
          image: const DecorationImage(
            image: AssetImage(MediaRes.testMap),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
