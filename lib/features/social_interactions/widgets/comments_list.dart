import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/services/injection_container.dart';
import 'package:social_ease_app/features/activity/domain/entities/comment.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';
import 'package:social_ease_app/features/points/presentation/cubit/points_cubit.dart';
import 'package:social_ease_app/features/social_interactions/widgets/comment_input_field.dart';
import 'package:social_ease_app/features/social_interactions/widgets/comment_tile.dart';
import 'package:social_ease_app/features/user/presentation/cubit/user_cubit.dart';

class CommentsList extends StatelessWidget {
  final List<ActivityComment> comments;
  final String activityId;

  const CommentsList({
    Key? key,
    required this.comments,
    required this.activityId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => sl<ActivityCubit>(),
            ),
            BlocProvider(
              create: (context) => sl<PointsCubit>(),
            ),
          ],
          child: CommentInputField(activityId: activityId),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: comments.length,
            itemBuilder: (context, index) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) =>
                        sl<ActivityCubit>()..getUser(comments[index].createdBy),
                  ),
                  BlocProvider(
                    create: (context) => sl<PointsCubit>(),
                  ),
                ],
                child: CommentTile(
                  comment: comments[index],
                  activityId: activityId,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
