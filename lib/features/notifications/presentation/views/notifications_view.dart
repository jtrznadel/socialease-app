import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/common/views/loading_view.dart';
import 'package:social_ease_app/core/common/widgets/gradient_background.dart';
import 'package:social_ease_app/core/common/widgets/nested_back_button.dart';
import 'package:social_ease_app/core/enums/notification_enum.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/core/utils/core_utils.dart';
import 'package:social_ease_app/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:social_ease_app/features/notifications/presentation/widgets/no_notifications.dart';
import 'package:social_ease_app/features/notifications/presentation/widgets/notification_options.dart';
import 'package:social_ease_app/features/notifications/presentation/widgets/notification_tile.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  bool loading = false;
  @override
  void initState() {
    context.read<NotificationCubit>().getNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: false,
        leading: const NestedBackButton(),
        actions: const [
          NotificationOptions(),
        ],
      ),
      body: GradientBackground(
        image: MediaRes.dashboardGradient,
        child: BlocConsumer<NotificationCubit, NotificationState>(
          listener: (context, state) {
            if (state is NotificationError) {
              CoreUtils.showSnackBar(context, state.message);
              context.pop();
            }
          },
          builder: (context, state) {
            if (state is GettingNotifications ||
                state is ClearingNotifications) {
              return const LoadingView();
            } else if (state is NotificationsLoaded &&
                state.notifications.isEmpty) {
              return const NoNotifications();
            } else if (state is NotificationsLoaded) {
              return ListView.builder(
                itemCount: state.notifications.length,
                itemBuilder: (_, index) {
                  final notification = state.notifications[index];
                  return NotificationTile(notification);
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
