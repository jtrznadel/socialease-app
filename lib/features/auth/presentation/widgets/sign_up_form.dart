import 'package:flutter/material.dart';
import 'package:social_ease_app/core/common/widgets/i_field.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
    required this.emailController,
    required this.fullNameController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.formKey,
  });

  final TextEditingController emailController;
  final TextEditingController fullNameController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final GlobalKey<FormState> formKey;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.formKey,
        child: Column(
          children: [
            IField(
              controller: widget.emailController,
              hintText: 'E-mail',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 15,
            ),
            IField(
              controller: widget.fullNameController,
              hintText: 'Full Name',
              keyboardType: TextInputType.text,
            ),
            const SizedBox(
              height: 15,
            ),
            IField(
              controller: widget.passwordController,
              hintText: 'Password',
              obscureText: obscurePassword,
              keyboardType: TextInputType.visiblePassword,
              suffixIcon: IconButton(
                onPressed: () => setState(
                  () {
                    obscurePassword = !obscurePassword;
                  },
                ),
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            IField(
                controller: widget.confirmPasswordController,
                hintText: 'Confirm Password',
                obscureText: obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                suffixIcon: IconButton(
                  onPressed: () => setState(
                    () {
                      obscurePassword = !obscurePassword;
                    },
                  ),
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.grey,
                  ),
                ),
                overrideValidator: true,
                validator: (value) {
                  if (value != widget.passwordController.text) {
                    return 'Password do not match';
                  }
                  return null;
                }),
          ],
        ));
  }
}
