import 'package:flutter/material.dart';
import 'package:social_ease_app/core/res/colors.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    required this.label,
    required this.onPressed,
    this.buttonColour,
    this.labelColour,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final Color? buttonColour;
  final Color? labelColour;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColour ?? AppColors.primaryColor,
        foregroundColor: labelColour ?? Colors.white,
        minimumSize: const Size(double.maxFinite, 50),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
