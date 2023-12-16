// ActivityInfoModal widget

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';

class ActivityInfoModal extends StatelessWidget {
  const ActivityInfoModal({Key? key, required this.activity}) : super(key: key);

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).size.height * 0.2;

    return Padding(
      padding: EdgeInsets.only(
        bottom: bottomPadding,
      ),
      child: Theme(
        data: ThemeData.dark().copyWith(
          // Set the modal background color to transparent
          canvasColor: Colors.transparent,
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 50),
          color: Colors
              .transparent, // Set the container color to transparent as well
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                activity.title,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                activity.category.label,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
              // Add more information as needed
              // ...
            ],
          ),
        ),
      ),
    );
  }
}
