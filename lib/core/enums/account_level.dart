import 'package:flutter/material.dart';

enum AccountLevel {
  rookie(
    label: 'Rookie',
    minRange: 0,
    maxRange: 500,
    color: Colors.blueGrey,
  ),
  activist(
    label: 'Activist',
    minRange: 501,
    maxRange: 1500,
    color: Colors.green,
  ),
  merchant(
    label: 'Social Merchant',
    minRange: 1501,
    maxRange: 2500,
    color: Colors.blue,
  ),
  veteran(
    label: 'Social Veteran',
    minRange: 2501,
    maxRange: 5000,
    color: Colors.purple,
  ),
  master(
    label: 'Social Master',
    minRange: 5001,
    maxRange: 99999,
    color: Colors.yellow,
  );

  const AccountLevel({
    required this.label,
    required this.minRange,
    required this.maxRange,
    required this.color,
  });
  final String label;
  final int minRange;
  final int maxRange;
  final Color color;
}
