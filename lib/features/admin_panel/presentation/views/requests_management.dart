import 'package:flutter/material.dart';
import 'package:social_ease_app/core/common/widgets/gradient_background.dart';
import 'package:social_ease_app/core/res/media_res.dart';

class RequestsManagementScreen extends StatefulWidget {
  const RequestsManagementScreen({super.key});

  static const routeName = '/users-management';

  @override
  State<RequestsManagementScreen> createState() =>
      _RequestsManagementScreenState();
}

class _RequestsManagementScreenState extends State<RequestsManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Requests Management'),
      ),
      body: const GradientBackground(
        image: MediaRes.dashboardGradient,
        child: Column(),
      ),
    );
  }
}
