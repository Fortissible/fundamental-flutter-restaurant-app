import 'package:equatable/equatable.dart';

abstract class NotificationState extends Equatable{
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInit extends NotificationState{}