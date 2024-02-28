import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_ease_app/core/common/widgets/user_profile_modal.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/features/activity/domain/entities/comment.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';

class CommentTile extends StatelessWidget {
  final ActivityComment comment;
  final String activityId;

  const CommentTile({Key? key, required this.comment, required this.activityId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityCubit, ActivityState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          LocalUser user = state.user;

          return ListTile(
            leading: GestureDetector(
              onTap: () {
                showUserProfileModal(context, user);
              },
              child: CircleAvatar(
                radius: 25,
                backgroundImage: user.profilePic != null
                    ? NetworkImage(user.profilePic!) as ImageProvider
                    : const AssetImage(MediaRes.defaultAvatarImage),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: Fonts.poppins,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.fieldInputColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        comment.content,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: Fonts.poppins,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          comment.likes == 0 ? '' : comment.likes.toString(),
                        ),
                        IconButton(
                            onPressed: () {
                              context.read<ActivityCubit>().likeComment(
                                  activityId: activityId,
                                  commentId: comment.id);
                            },
                            icon: const Icon(Icons.favorite)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            subtitle: Text(
              DateFormat.yMMMd().format(comment.createdAt),
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 10,
                fontFamily: Fonts.poppins,
              ),
            ),
          );
        } else {
          // Show a loading indicator or a placeholder
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
