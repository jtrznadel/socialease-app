import 'package:flutter/material.dart';
import 'package:social_ease_app/core/res/colors.dart';

class TagTile extends StatelessWidget {
  const TagTile({super.key, required this.tag});

  final String tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          border: Border.all(
            color: Colors.black,
            width: 1,
          )),
      child: Text(tag),
    );
  }
}
