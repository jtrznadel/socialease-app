import 'package:flutter/material.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  static const routeName = '/dashboard';
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'DASHBOARD SCREEN',
        style: context.theme.textTheme.bodyLarge,
      ),
    );
  }
}