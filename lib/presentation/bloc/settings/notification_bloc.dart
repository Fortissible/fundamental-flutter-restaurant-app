
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant_app/presentation/bloc/settings/notification_event.dart';
import 'package:flutter_restaurant_app/presentation/bloc/settings/notification_state.dart';

import '../../../core/utils/background_service.dart';
import '../../../core/utils/date_time_helper.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState>{

  NotificationBloc() : super(NotificationInit()){
    on<NotificationSetEvent>((event,emit) async {
      await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format("11:00:00"),
        exact: true,
        wakeup: true,
      );
    });

    on<NotificationCancelEvent>((event,emit) async{
      await AndroidAlarmManager.cancel(1);
    });
  }
}