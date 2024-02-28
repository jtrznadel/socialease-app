import 'package:flutter/widgets.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/features/home/presentation/widgets/tinder_cards.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Activity of the day',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: Fonts.poppins,
                ),
              ),
            ],
          ),
          Positioned(
            top: context.height >= 926
                ? -80
                : context.height >= 844
                    ? -80
                    : context.height <= 800
                        ? -80
                        : 70,
            right: -14,
            child: const TinderCards(),
          ),
        ],
      ),
    );
  }
}
