import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:social_ease_app/core/res/fonts.dart';

class StatsElement extends StatelessWidget {
  const StatsElement({
    super.key,
    required this.color,
    required this.icon,
    required this.text,
    required this.value,
  });

  final Color color;
  final IconData icon;
  final String text;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DashedCircularProgressBar.square(
          dimensions: 50,
          progress: 100,
          maxProgress: 100,
          foregroundColor: color,
          foregroundStrokeWidth: 4,
          animation: true,
          child: Icon(
            icon,
            color: color,
            size: 30,
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            fontFamily: Fonts.poppins,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontFamily: Fonts.poppins,
          ),
        ),
      ],
    );
  }
}
