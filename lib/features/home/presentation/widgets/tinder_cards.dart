import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/features/home/presentation/widgets/tinder_card.dart';

class TinderCards extends StatefulWidget {
  const TinderCards({super.key});

  @override
  State<TinderCards> createState() => _TinderCardsState();
}

class _TinderCardsState extends State<TinderCards>
    with TickerProviderStateMixin {
  final cardController = CardController();

  int totalCards = 10;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: context.width,
        height: context.width,
        child: TinderSwapCard(
          totalNum: totalCards,
          swipeEdge: 4,
          maxWidth: context.width,
          maxHeight: context.width * .9,
          minWidth: context.width * .71,
          minHeight: context.width * .6,
          cardController: cardController,
          allowSwipe: false,
          swipeUpdateCallback:
              (DragUpdateDetails details, Alignment alignment) {
            if (alignment.x < 0) {
            } else if (alignment.x > 0) {}
          },
          swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
            if (index == totalCards - 1) {
              setState(() {
                totalCards += 10;
              });
            }
          },
          cardBuilder: (context, index) {
            final isFirst = index == 0;
            final colorByIndex = index == 1 ? Colors.yellow : Colors.purple;
            return Stack(
              children: [
                Positioned(
                  bottom: 110,
                  left: 0,
                  right: 0,
                  child: TinderCard(
                    isFirst: isFirst,
                    color: isFirst ? null : colorByIndex,
                  ),
                ),
                if (isFirst)
                  Positioned(
                      bottom: 85,
                      right: -20,
                      child: Image.asset(
                        MediaRes.activityOfTheDay,
                        height: 180,
                        width: 150,
                      ))
              ],
            );
          },
        ),
      ),
    );
  }
}
