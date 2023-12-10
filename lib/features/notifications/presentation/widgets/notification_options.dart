import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:social_ease_app/core/common/app/providers/notification_notifier.dart';
import 'package:social_ease_app/core/common/widgets/popup_item.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/features/notifications/presentation/cubit/notification_cubit.dart';

class NotificationOptions extends StatelessWidget {
  const NotificationOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationsNotifier>(
      builder: (_, notifier, __) {
        return PopupMenuButton(
          offset: const Offset(0, 50),
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          itemBuilder: (context) => [
            PopupMenuItem<void>(
              onTap: notifier.toggleMuteNotifications,
              child: PopupItem(
                title: notifier.muteNotifications
                    ? 'Unmute Notifications'
                    : 'Mute Notifications',
                icon: notifier.muteNotifications
                    ? const Icon(
                        Icons.notifications_off_outlined,
                        color: AppColors.secondaryTextColor,
                      )
                    : const Icon(
                        Icons.notifications_outlined,
                        color: AppColors.secondaryTextColor,
                      ),
              ),
            ),
            PopupMenuItem<void>(
              onTap: context.read<NotificationCubit>().clearAll,
              child: const PopupItem(
                title: 'Clear All',
                icon: Icon(
                  Icons.check_circle_outlined,
                  color: AppColors.secondaryTextColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
