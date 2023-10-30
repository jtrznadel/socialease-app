import 'package:flutter/material.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const routeName = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'SIGN IN SCREEN',
        style: context.theme.textTheme.bodyLarge,
      ),
    );
  }
}
