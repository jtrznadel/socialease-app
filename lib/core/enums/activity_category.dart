import 'package:flutter/material.dart';
import 'package:social_ease_app/core/res/media_res.dart';

enum ActivityCategory {
  charity(
    label: 'Charity',
    image: MediaRes.charity,
    icon: Icons.people,
  ),
  animalWelfare(
    label: 'Animal Welfare',
    image: MediaRes.animalWelfare,
    icon: Icons.pets,
  ),
  foodAndHunger(
    label: 'Hunger',
    image: MediaRes.foodAndHunger,
    icon: Icons.food_bank,
  ),
  disasterRelief(
    label: 'Disaster Relief',
    image: MediaRes.disasterRelief,
    icon: Icons.local_hospital,
  ),
  elderlyCare(
    label: 'Elderly Care',
    image: MediaRes.elderlyCare,
    icon: Icons.supervisor_account,
  ),
  homelessness(
    label: 'Homelessness',
    image: MediaRes.homelessness,
    icon: Icons.hotel,
  ),
  education(
    label: 'Education',
    image: MediaRes.education,
    icon: Icons.school,
  ),
  environment(
    label: 'Environment',
    image: MediaRes.environment,
    icon: Icons.eco,
  );

  const ActivityCategory(
      {required this.label, required this.image, required this.icon});
  final String label;
  final String image;
  final IconData icon;
}
