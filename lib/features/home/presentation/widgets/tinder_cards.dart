import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:provider/provider.dart';
import 'package:social_ease_app/core/common/app/providers/activity_of_the_day_notifier.dart';
import 'package:social_ease_app/core/common/widgets/blank_tile.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/home/presentation/widgets/tinder_card.dart';

class TinderCards extends StatefulWidget {
  const TinderCards({super.key});

  @override
  State<TinderCards> createState() => _TinderCardsState();
}

class _TinderCardsState extends State<TinderCards>
    with TickerProviderStateMixin {
  final cardController = CardController();

  int totalCards = 2;
  late List<Activity> activities;

  @override
  Widget build(BuildContext context) {
    activities = context.read<ActivityOfTheDayNotifier>().activitiesOfTheDay!;
    return Center(
      child: SizedBox(
        width: context.width,
        height: context.width,
        child: TinderSwapCard(
          totalNum: activities.length <= 2 ? activities.length : totalCards,
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
              // Swiping left
            } else if (alignment.x > 0) {
              // Swiping right
            }
          },
          swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
            if (index == totalCards - 1) {
              setState(() {
                totalCards += 10;
              });
            }
          },
          cardBuilder: (context, index) {
            if (index >= activities.length) {
              // No more cards, return BlankTile()
              return const BlankTile(
                text: 'test',
              );
            }

            final isFirst = index == 0;
            final colorByIndex = index == 1 ? Colors.yellow : Colors.purple;

            return Stack(
              children: [
                Positioned(
                  bottom: 110,
                  left: 0,
                  right: 0,
                  child: TinderCard(
                    activity: activities[index],
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
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
