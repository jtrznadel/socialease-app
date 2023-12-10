import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/common/app/providers/notification_notifier.dart';
import 'package:social_ease_app/core/common/widgets/time_text.dart';
import 'package:social_ease_app/features/notifications/domain/entities/notification.dart';
import 'package:social_ease_app/features/notifications/presentation/cubit/notification_cubit.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile(this.notification, {super.key});

  final Notification notification;

  @override
  Widget build(BuildContext context) {
    // if (!notification.seen) {
    //   context.read<NotificationCubit>().markAsRead(notification.id);
    // }
    return BlocListener<NotificationCubit, NotificationState>(
      listener: (_, state) {},
      child: Dismissible(
        key: Key(notification.id),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 15),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        onDismissed: (_) {
          context.read<NotificationCubit>().clear(notification.id);
        },
        child: ListTile(
          leading: Icon(notification.category.icon),
          title: Text(
            notification.title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          subtitle: TimeText(time: notification.sentAt),
        ),
      ),
    );
  }
}
