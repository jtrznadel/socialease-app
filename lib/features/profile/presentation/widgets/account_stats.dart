import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/features/points/presentation/cubit/points_cubit.dart';

class AccountStats extends StatelessWidget {
  const AccountStats({
    super.key,
    required this.points,
    required this.activityCounter,
  });

  final int points;
  final int activityCounter;

  @override
  Widget build(BuildContext context) {
    context.read<PointsCubit>().getAllTimeRanking();
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
        border: Border.all(color: Colors.black.withOpacity(.6), width: 2),
        color: Colors.transparent,
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                BlocBuilder<PointsCubit, PointsState>(
                  builder: (context, state) {
                    if (state is PointsError) {
                      return Text(
                        '#999',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            fontFamily: Fonts.poppins),
                      );
                    } else if (state is AllTimeRankingLoaded) {
                      var positon = state.allTimeRanking
                          .where((position) =>
                              position.userId == context.currentUser!.uid)
                          .first;
                      return Text(
                        '#${positon.position}',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            fontFamily: Fonts.poppins),
                      );
                    }
                    return Text(
                      '#999',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          fontFamily: Fonts.poppins),
                    );
                  },
                ),
                Text(
                  'top rank',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: Fonts.poppins),
                ),
              ],
            ),
            const VerticalDivider(
              color: Colors.grey,
            ),
            Column(
              children: [
                Text(
                  '$points',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: Fonts.poppins),
                ),
                Text(
                  'points',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: Fonts.poppins),
                ),
              ],
            ),
            const VerticalDivider(
              color: Colors.grey,
            ),
            Column(
              children: [
                Text(
                  '$activityCounter',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: Fonts.poppins),
                ),
                Text(
                  'activities',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: Fonts.poppins),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
