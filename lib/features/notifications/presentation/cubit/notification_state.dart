part of 'notification_cubit.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

final class NotificationInitial extends NotificationState {}

final class GettingNotifications extends NotificationState {
  const GettingNotifications();
}

final class SendingNotification extends NotificationState {
  const SendingNotification();
}

final class ClearingNotifications extends NotificationState {
  const ClearingNotifications();
}

final class NotificationsLoaded extends NotificationState {
  const NotificationsLoaded(this.notifications);
  final List<Notification> notifications;

  @override
  List<Object> get props => notifications;
}

final class NotificationsSent extends NotificationState {
  const NotificationsSent();
}

final class NotificationsCleared extends NotificationState {
  const NotificationsCleared();
}

final class NotificationError extends NotificationState {
  const NotificationError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
