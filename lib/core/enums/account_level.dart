import 'package:flutter/material.dart';

enum AccountLevel {
  rookie(
    label: 'Rookie',
    minRange: 0,
    maxRange: 500,
    color: Colors.blueGrey,
    multiplier: 1.0,
  ),
  activist(
      label: 'Activist',
      minRange: 501,
      maxRange: 1500,
      color: Colors.green,
      multiplier: 1.2),
  merchant(
      label: 'Social Merchant',
      minRange: 1501,
      maxRange: 2500,
      color: Colors.blue,
      multiplier: 1.3),
  veteran(
      label: 'Social Veteran',
      minRange: 2501,
      maxRange: 5000,
      color: Colors.purple,
      multiplier: 1.4),
  master(
      label: 'Social Master',
      minRange: 5001,
      maxRange: 99999,
      color: Colors.yellow,
      multiplier: 1.8);

  const AccountLevel({
    required this.label,
    required this.minRange,
    required this.maxRange,
    required this.color,
    required this.multiplier,
  });
  final String label;
  final int minRange;
  final int maxRange;
  final Color color;
  final double multiplier;
}
