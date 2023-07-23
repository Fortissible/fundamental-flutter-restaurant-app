import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class NotificationSetEvent extends NotificationEvent {
  const NotificationSetEvent();

  @override
  List<Object?> get props => [];
}

class NotificationCancelEvent extends NotificationEvent {
  const NotificationCancelEvent();

  @override
  List<Object?> get props => [];
}