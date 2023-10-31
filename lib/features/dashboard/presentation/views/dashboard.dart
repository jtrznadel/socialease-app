import 'package:flutter/material.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/features/auth/presentation/views/sign_in_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  static const routeName = '/dashboard';
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'DASHBOARD SCREEN',
              style: context.theme.textTheme.bodyLarge,
            ),
            TextButton(
                onPressed: () {
                  Navigator.popAndPushNamed(context, SignInScreen.routeName);
                },
                child: const Text('Push'))
          ],
        ),
      ),
    );
  }
}
