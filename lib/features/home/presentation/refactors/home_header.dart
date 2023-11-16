import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:social_ease_app/core/common/app/providers/user_provider.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/features/home/presentation/widgets/tinder_cards.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: Stack(
        children: [
          RichText(
            text: TextSpan(
                text: 'Hello, ',
                style: const TextStyle(
                    fontSize: 26,
                    color: AppColors.primaryTextColor,
                    fontWeight: FontWeight.w400),
                children: [
                  TextSpan(
                    text: (context.watch<UserProvider>().user!.fullName)
                        .split(' ')[0],
                    style: const TextStyle(
                      fontSize: 38,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ]),
          ),
          Positioned(
            top: context.height >= 926
                ? -80
                : context.height >= 844
                    ? -60
                    : context.height <= 800
                        ? 70
                        : 70,
            right: -14,
            child: const TinderCards(),
          ),
        ],
      ),
    );
  }
}
