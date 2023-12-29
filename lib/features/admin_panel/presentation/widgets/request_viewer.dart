import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/enums/activity_status.dart';
import 'package:social_ease_app/core/enums/notification_enum.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/core/utils/core_utils.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';
import 'package:social_ease_app/features/notifications/data/models/notification_model.dart';
import 'package:social_ease_app/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:social_ease_app/features/points/presentation/cubit/points_cubit.dart';

class RequestViewer extends StatefulWidget {
  const RequestViewer({super.key, required this.requests});

  final List<Activity> requests;

  @override
  State<RequestViewer> createState() => _RequestViewerState();
}

class _RequestViewerState extends State<RequestViewer> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.requests.isNotEmpty
            ? Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView(
                      children: [
                        SizedBox(
                          child: widget.requests[_currentIndex].image == null
                              ? Image.asset(MediaRes.defaultActivityBackground)
                              : Image.network(
                                  widget.requests[_currentIndex].image!),
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        Text(
                          'Title: ${widget.requests[_currentIndex].title}',
                          style: const TextStyle(fontSize: 24),
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        Text(
                          'Description: ${widget.requests[_currentIndex].description}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        Text(
                          'Tags: ${widget.requests[_currentIndex].tags.join(' ,')}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        Text(
                          'Location: ${widget.requests[_currentIndex].location}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        const Text(
                          'Time: 23rd December 2023',
                          //TODO: implement time property
                          style: TextStyle(fontSize: 16),
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      color: AppColors.secondaryColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              setState(() {
                                _currentIndex = (_currentIndex + 1) %
                                    widget.requests.length;
                              });
                            },
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FloatingActionButton(
                              onPressed: () {
                                showTextInputDialog(
                                  context: context,
                                  textFields: [
                                    const DialogTextField(initialText: ''),
                                  ],
                                  title: 'Reason for Denying',
                                  okLabel: 'Submit',
                                  cancelLabel: 'Cancel',
                                ).then((result) {
                                  Future.microtask(() {
                                    if (result != null) {
                                      String denyReason = result[0];
                                      submitDenial(denyReason);
                                    } else {
                                      SystemNavigator.pop();
                                    }
                                  });
                                });
                              },
                              heroTag: 'denyButton',
                              backgroundColor: Colors.red,
                              child: Text(
                                'Deny',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: Fonts.poppins,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: BlocListener<NotificationCubit,
                                NotificationState>(
                              listener: (context, state) {
                                if (state is NotificationError) {
                                  CoreUtils.showSnackBar(
                                      context, state.message);
                                } else if (state is NotificationsSent) {
                                  CoreUtils.showSnackBar(
                                      context, "Notification has been sent");
                                }
                              },
                              child: FloatingActionButton(
                                onPressed: () {
                                  final notification =
                                      NotificationModel.empty().copyWith(
                                    title: "Activity has been accepted",
                                    body: "Activity is now visible on socials.",
                                    category:
                                        NotificationCategory.activityFeedback,
                                  );
                                  context
                                      .read<NotificationCubit>()
                                      .sendNotificationToUser(
                                        userId: widget
                                            .requests[_currentIndex].createdBy,
                                        notification: notification,
                                      );
                                  context.read<PointsCubit>().addPoints(
                                      userId: widget
                                          .requests[_currentIndex].createdBy,
                                      points: 399);
                                  context
                                      .read<ActivityCubit>()
                                      .updateActivityStatus(
                                        status: ActivityStatus.verified,
                                        activityId:
                                            widget.requests[_currentIndex].id,
                                      );
                                  widget.requests.removeAt(_currentIndex);

                                  if (_currentIndex >= widget.requests.length) {
                                    _currentIndex = 0;
                                  }

                                  setState(() {});
                                },
                                heroTag: 'acceptButton',
                                backgroundColor: Colors.green,
                                child: Text(
                                  'Accept',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: Fonts.poppins,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () {
                              setState(() {
                                _currentIndex = (_currentIndex - 1) %
                                    widget.requests.length;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : const Center(
                child: Text("No requests left"),
              ));
  }

  void submitDenial(String denyReason) {
    final notification = NotificationModel.empty().copyWith(
      title: "Activity has not been accepted",
      body: "Reason: $denyReason",
      category: NotificationCategory.activityFeedback,
      sentAt: DateTime.now(),
    );
    context.read<NotificationCubit>().sendNotificationToUser(
          userId: widget.requests[_currentIndex].createdBy,
          notification: notification,
        );
    context.read<ActivityCubit>().updateActivityStatus(
          status: ActivityStatus.declined,
          activityId: widget.requests[_currentIndex].id,
        );
    widget.requests.removeAt(_currentIndex);

    if (_currentIndex >= widget.requests.length) {
      _currentIndex = 0;
    }
    setState(() {});
  }
}
