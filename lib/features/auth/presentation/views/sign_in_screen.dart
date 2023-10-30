import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/common/app/provides/user_provider.dart';
import 'package:social_ease_app/core/common/widgets/gradient_background.dart';
import 'package:social_ease_app/core/common/widgets/rounded_button.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/core/utils/core_utils.dart';
import 'package:social_ease_app/features/auth/data/models/user_model.dart';
import 'package:social_ease_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:social_ease_app/features/auth/presentation/views/sign_up_screen.dart';
import 'package:social_ease_app/features/auth/presentation/widgets/sign_in_form.dart';
import 'package:social_ease_app/features/dashboard/presentation/views/dashboard.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const routeName = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) {
          if (state is AuthError) {
            CoreUtils.showSnackBar(context, state.message);
          } else if (state is SignedIn) {
            context.read<UserProvider>().initUser(state.user as LocalUserModel);
            Navigator.pushReplacementNamed(context, Dashboard.routeName);
          }
        },
        builder: (context, state) {
          return GradientBackground(
              image: MediaRes.onBoardingGradient,
              child: SafeArea(
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      Text(
                        'Witness the Beauty of Compassion.',
                        style: TextStyle(
                          fontFamily: Fonts.montserrat,
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Image.asset(
                        MediaRes.signInImage,
                        height: context.height * .3,
                        width: context.width * .8,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SignInForm(
                        emailController: emailController,
                        passwordController: passwordController,
                        formKey: formKey,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgot-password');
                          },
                          child: const Text(
                            'Forgot password?',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      state is AuthLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : RoundedButton(
                              label: 'Sign In',
                              onPressed: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                FirebaseAuth.instance.currentUser?.reload();
                                if (formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(
                                        SignInEvent(
                                          email: emailController.text.trim(),
                                          password:
                                              passwordController.text.trim(),
                                        ),
                                      );
                                }
                              },
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            'Do not have an account yet?',
                            style: TextStyle(fontSize: 14),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, SignUpScreen.routeName);
                            },
                            child: const Text('Register now!'),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}
