import 'package:flutter/material.dart';
import 'package:social_ease_app/core/common/widgets/stats_element.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';

class OngoingActivityPage extends StatelessWidget {
  const OngoingActivityPage({
    Key? key,
    required this.activity,
  }) : super(key: key);

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: NetworkImage(
              activity.image!), // Assuming activity.image is a URL to the image
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Text('test'),
    );
  }
}
