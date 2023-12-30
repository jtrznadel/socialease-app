import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/material.dart';

class StatsElement extends StatelessWidget {
  const StatsElement({
    super.key,
    required this.color,
    required this.icon,
    required this.text,
  });

  final Color color;
  final IconData icon;
  final String text;

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
            size: 25,
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
