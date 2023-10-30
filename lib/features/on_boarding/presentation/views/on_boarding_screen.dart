import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:social_ease_app/core/common/views/loading_view.dart';
import 'package:social_ease_app/core/common/widgets/gradient_background.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/features/on_boarding/domain/entities/page_content.dart';
import 'package:social_ease_app/features/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:social_ease_app/features/on_boarding/presentation/widgets/on_boarding_body.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  static const routeName = "/";

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final pageController = PageController();
  @override
  void initState() {
    super.initState();
    context.read<OnBoardingCubit>().checkIfUserIsFirstTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GradientBackground(
        image: MediaRes.onBoardingGradient,
        child: BlocConsumer<OnBoardingCubit, OnBoardingState>(
          listener: (context, state) {
            if (state is OnBoardingStatus && !state.isFirstTimer) {
              Navigator.pushReplacementNamed(context, '/home');
            } else if (state is UserCached) {
              Navigator.pushReplacementNamed(context, '/');
            }
          },
          builder: (context, state) {
            if (state is CheckingIfUserIsFirstTimer ||
                state is CachingFirstTimer) {
              return const LoadingView();
            }
            return Stack(
              children: [
                PageView(
                  controller: pageController,
                  children: [
                    OnBoardingBody(
                      pageContent: PageContent.firstPage(),
                    ),
                    OnBoardingBody(
                      pageContent: PageContent.secondPage(),
                    ),
                    OnBoardingBody(
                      pageContent: PageContent.thirdPage(),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: 3,
                    onDotClicked: (index) {
                      pageController.animateToPage(index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.decelerate);
                    },
                    effect: const WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      spacing: 40,
                      activeDotColor: AppColors.primaryColor,
                      dotColor: Colors.white,
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
