import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/material.dart';

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
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
