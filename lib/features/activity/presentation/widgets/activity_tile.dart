import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_ease_app/core/common/app/providers/favorite_activities_notifier.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';

class ActivityTile extends StatelessWidget {
  const ActivityTile({Key? key, required this.activity, required this.onTap})
      : super(key: key);

  final Activity activity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ImageProvider<Object> image = activity.image != null
        ? NetworkImage(activity.image!) as ImageProvider
        : const AssetImage(MediaRes.defaultActivityBackground);

    final ImageProvider<Object> userAvatar =
        context.currentUser?.profilePic != null
            ? NetworkImage(context.currentUser!.profilePic!) as ImageProvider
            : const AssetImage(MediaRes.defaultAvatarImage);
    final fullName = context.currentUser?.fullName ?? 'Unknown';
    final name =
        fullName.length <= 20 ? fullName : '${fullName.split(' ')[0]} ...';

    activity.tags.sort((a, b) => b.length.compareTo(a.length));
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.width,
        height: context.height * .25,
        decoration: BoxDecoration(
          color: AppColors.thirdColor,
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: image,
            fit: BoxFit.cover,
          ),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 2),
              blurRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0).copyWith(top: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          context
                              .read<FavoriteActivitiesNotifier>()
                              .addActivityToFavorites(activity);
                        },
                        icon: const Icon(
                          Icons.favorite_border_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: userAvatar,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: Fonts.montserrat,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: AppColors.bgColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            children: [
                              Icon(activity.category.icon),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(activity.category.label),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  color: AppColors.bgColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      activity.title.length <= 30
                          ? activity.title
                          : '${activity.title.substring(0, 31)}...',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: Fonts.montserrat,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      activity.description.length <= 40
                          ? activity.description
                          : '${activity.description.substring(0, 41)}...',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: Fonts.montserrat,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          activity.tags.join(', ').length >= 30
                              ? '${activity.tags.join(', ').substring(0, 29)}...'
                              : activity.tags.join(', '),
                          style: const TextStyle(
                              color: AppColors.secondaryTextColor),
                        ),
                        const Text('300 m')
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
