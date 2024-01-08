import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/entities/activity_details_arguments.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';
import 'package:social_ease_app/features/activity/presentation/views/activity_details_screen.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';

class OngoingActivityPage extends StatefulWidget {
  const OngoingActivityPage({
    Key? key,
    required this.activity,
  }) : super(key: key);

  final Activity activity;

  @override
  State<OngoingActivityPage> createState() => _OngoingActivityPageState();
}

class _OngoingActivityPageState extends State<OngoingActivityPage> {
  @override
  void initState() {
    context.read<ActivityCubit>().getUser(widget.activity.createdBy);
    super.initState();
  }

  LocalUser? user;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ActivityCubit, ActivityState>(
      listener: (context, state) {
        if (state is UserLoaded) {
          setState(() {
            user = state.user;
          });
        }
      },
      builder: (context, state) {
        if (state is GettingUser) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserLoaded && user != null) {
          return GestureDetector(
            onTap: () {
              final arguments = ActivityDetailsArguments(
                activity: widget.activity,
                user: user!,
              );

              Navigator.of(context).pushNamed(
                ActivityDetailsScreen.routeName,
                arguments: arguments,
              );
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
                color: Colors.white,
                image: const DecorationImage(
                  image: AssetImage(MediaRes.blackBg),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  Text(
                    widget.activity.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: Fonts.poppins,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(widget.activity.image!),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            widget.activity.category.label,
                            style: TextStyle(
                              fontFamily: Fonts.poppins,
                            ),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Icon(widget.activity.category.icon),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
