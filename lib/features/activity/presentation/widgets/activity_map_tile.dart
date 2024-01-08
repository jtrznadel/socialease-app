import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/entities/activity_details_arguments.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/utils/core_utils.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';
import 'package:social_ease_app/features/activity/presentation/views/activity_details_screen.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';

class MapActivityTile extends StatefulWidget {
  const MapActivityTile({
    super.key,
    required this.selectedActivity,
  });

  final Activity selectedActivity;

  @override
  State<MapActivityTile> createState() => _MapActivityTileState();
}

class _MapActivityTileState extends State<MapActivityTile> {
  LocalUser? user;
  @override
  void initState() {
    context.read<ActivityCubit>().getUser(widget.selectedActivity.createdBy);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActivityCubit, ActivityState>(
      listener: (context, state) {
        if (state is ActivityError) {
          CoreUtils.showSnackBar(context, state.message);
        } else if (state is UserLoaded) {
          setState(() {
            user = state.user;
          });
        }
      },
      child: GestureDetector(
        onTap: () {
          final arguments = ActivityDetailsArguments(
            activity: widget.selectedActivity,
            user: user!,
          );

          Navigator.of(context).pushNamed(
            ActivityDetailsScreen.routeName,
            arguments: arguments,
          );
        },
        child: SizedBox(
          height: context.height * .35,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(5).copyWith(bottom: 0),
                height: context.height * .2,
                width: context.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    widget.selectedActivity.image!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                left: 0,
                bottom: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  width: context.width,
                  height: context.height * .2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.selectedActivity.title.length > 30
                            ? '${widget.selectedActivity.title.substring(0, 30)}...'
                            : widget.selectedActivity.title,
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryTextColor,
                          fontFamily: Fonts.poppins,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            widget.selectedActivity.category.label,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondaryTextColor,
                              fontFamily: Fonts.poppins,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Icon(widget.selectedActivity.category.icon),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        widget.selectedActivity.description,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                          fontFamily: Fonts.poppins,
                        ),
                        textAlign: TextAlign.justify,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
