import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:social_ease_app/core/entities/activity_details_arguments.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';
import 'package:social_ease_app/features/activity/presentation/views/activity_details_screen.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';

class CustomMarker extends Marker {
  CustomMarker({
    required double width,
    required double height,
    required LatLng point,
    required Activity activity,
  }) : super(
          width: width,
          height: height,
          point: point,
          child: CustomMarkerWidget(
            width: width,
            height: height,
            activity: activity,
          ),
        );
}

class CustomMarkerWidget extends StatefulWidget {
  const CustomMarkerWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.activity,
  }) : super(key: key);

  final double width;
  final double height;
  final Activity activity;

  @override
  State<CustomMarkerWidget> createState() => _CustomMarkerWidgetState();
}

class _CustomMarkerWidgetState extends State<CustomMarkerWidget> {
  LocalUser? user;

  @override
  void initState() {
    context.read<ActivityCubit>().getUser(widget.activity.createdBy);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActivityCubit, ActivityState>(
      listener: (context, state) {
        if (state is UserLoaded) {
          setState(() {
            user = state.user;
          });
        }
      },
      child: GestureDetector(
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
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Image
              Container(
                width: widget.width,
                height: widget.height * 0.4,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(8.0)),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        widget.activity.image!), // Replace with your image URL
                  ),
                ),
              ),
              // Title
              Expanded(
                child: Container(
                  width: widget.width,
                  padding: const EdgeInsets.all(4.0),
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(8.0)),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.activity.title,
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2.0),
                      // Activity Category
                      Text(
                        widget.activity.category.label,
                        style: const TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
