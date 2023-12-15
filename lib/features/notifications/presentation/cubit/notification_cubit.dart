import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:social_ease_app/core/errors/failures.dart';
import 'package:social_ease_app/features/notifications/domain/entities/notification.dart';
import 'package:social_ease_app/features/notifications/domain/usecases/clear.dart';
import 'package:social_ease_app/features/notifications/domain/usecases/clear_all.dart';
import 'package:social_ease_app/features/notifications/domain/usecases/get_notifications.dart';
import 'package:social_ease_app/features/notifications/domain/usecases/mark_as_read.dart';
import 'package:social_ease_app/features/notifications/domain/usecases/send_notification.dart';
import 'package:social_ease_app/features/notifications/domain/usecases/send_notification_to_user.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit({
    required ClearAll clearAll,
    required Clear clear,
    required GetNotifications getNotifications,
    required SendNotification sendNotification,
    required SendNotificationToUser sendNotificationToUser,
    required MarkAsRead markAsRead,
  })  : _clearAll = clearAll,
        _clear = clear,
        _getNotifications = getNotifications,
        _sendNotification = sendNotification,
        _sendNotificationToUser = sendNotificationToUser,
        _markAsRead = markAsRead,
        super(NotificationInitial());

  final Clear _clear;
  final ClearAll _clearAll;
  final GetNotifications _getNotifications;
  final SendNotification _sendNotification;
  final SendNotificationToUser _sendNotificationToUser;
  final MarkAsRead _markAsRead;

  Future<void> clear(String notificationId) async {
    emit(const ClearingNotifications());
    final result = await _clear(notificationId);
    result.fold(
      (failure) => emit(NotificationError(failure.errorMessage)),
      (_) => emit(NotificationInitial()),
    );
  }

  Future<void> clearAll() async {
    emit(const ClearingNotifications());
    final result = await _clearAll();
    result.fold(
      (failure) => emit(NotificationError(failure.errorMessage)),
      (_) => emit(NotificationInitial()),
    );
  }

  Future<void> sendNotification(Notification notification) async {
    emit(const SendingNotification());
    final result = await _sendNotification(notification);
    result.fold(
      (failure) => emit(NotificationError(failure.errorMessage)),
      (_) => emit(const NotificationsSent()),
    );
  }

  Future<void> sendNotificationToUser(
      {required String userId, required Notification notification}) async {
    emit(const SendingNotification());
    final result = await _sendNotificationToUser(SendNotificationToUserParams(
        userId: userId, notification: notification));
    result.fold(
      (failure) => emit(NotificationError(failure.errorMessage)),
      (_) => emit(const NotificationsSent()),
    );
  }

  Future<void> markAsRead(String notificationid) async {
    final result = await _markAsRead(notificationid);
    result.fold(
      (failure) => emit(NotificationError(failure.errorMessage)),
      (_) => emit(NotificationInitial()),
    );
  }

  void getNotifications() {
    emit(const GettingNotifications());
    StreamSubscription<Either<Failure, List<Notification>>>? subscription;
    subscription = _getNotifications().listen(
      (result) {
        if (isClosed) return;

        result.fold(
          (failure) {
            emit(NotificationError(failure.errorMessage));
            subscription?.cancel();
          },
          (notifications) => emit(NotificationsLoaded(notifications)),
        );
      },
      onError: (error) {
        emit(NotificationError(error));
        subscription?.cancel();
      },
      onDone: () {
        subscription?.cancel();
      },
    );
  }
}
