import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/entities/activity_details_arguments.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';
import 'package:social_ease_app/features/activity/presentation/views/activity_details_screen.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';
import 'package:percent_indicator/percent_indicator.dart';

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
    var toEnd = widget.activity.endDate!.difference(DateTime.now()).inDays;
    var percentage = toEnd / 31;
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
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                image: const DecorationImage(
                  image: AssetImage(MediaRes.blackBg),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(widget.activity.image!),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        widget.activity.title.length > 20
                            ? '${widget.activity.title.substring(0, 20)}...'
                            : widget.activity.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: Fonts.poppins,
                          fontWeight: FontWeight.w600,
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
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('$toEnd days left'),
                      const SizedBox(
                        height: 2,
                      ),
                      LinearPercentIndicator(
                        width: context.width * .5,
                        lineHeight: 15,
                        percent: percentage,
                        backgroundColor: Colors.grey,
                        progressColor: percentage >= .66
                            ? Colors.green
                            : percentage >= .33
                                ? Colors.yellow
                                : Colors.red,
                        barRadius: const Radius.circular(50),
                      ),
                    ],
                  )
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
