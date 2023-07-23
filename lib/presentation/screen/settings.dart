import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant_app/core/utils/sharedprefs.dart';
import 'package:flutter_restaurant_app/presentation/bloc/settings/notification_bloc.dart';
import 'package:flutter_restaurant_app/presentation/bloc/settings/notification_event.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/utils/notification_helper.dart';


class SettingsPage extends StatefulWidget{
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  late bool _isFilterToggled;

  @override
  void initState() {
    _isFilterToggled = SettingsSharedPreferences.getNotifPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
              "Notification Settings"
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Aktifkan Notifikasi",
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.normal
                ),
              ),
              SizedBox(
                width: 50,
                height: 20,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Switch(
                      value: _isFilterToggled,
                      activeColor: Colors.blueAccent,
                      onChanged: (isToogled){
                        setState(() {
                          _isFilterToggled = !_isFilterToggled;
                        });
                        if (isToogled){
                          context.read<NotificationBloc>().add(
                              const NotificationSetEvent()
                          );
                          showSnackBar(context, "Notification Aktif");
                        } else {
                          context.read<NotificationBloc>().add(
                              const NotificationCancelEvent()
                          );
                          showSnackBar(context, "Notification Non Aktif");
                        }
                        SettingsSharedPreferences.setNotifPrefs(_isFilterToggled);
                      }
                  ),
                ),
              )
            ],
          ),
        )
    );
  }

  void showSnackBar(BuildContext context, String content){
    final snackBar = SnackBar(
      content: Center(
        child: Text(
          content,
          style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.normal
          ),
        ),
      ),
      backgroundColor: Colors.blueAccent,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 2500),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }
}