import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_restaurant_app/core/utils/sharedprefs.dart';
import 'package:flutter_restaurant_app/presentation/bloc/favourite/resto_fav_bloc.dart';
import 'package:flutter_restaurant_app/presentation/bloc/settings/notification_bloc.dart';
import 'package:flutter_restaurant_app/presentation/screen/favourite_restaurant.dart';
import 'package:flutter_restaurant_app/presentation/screen/settings.dart';
import 'package:flutter_restaurant_app/presentation/widget/restaurant_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_restaurant_app/di/injection.dart' as di;

import '../../core/utils/background_service.dart';
import '../../core/utils/debouncer.dart';
import '../../core/utils/navigation.dart';
import '../../core/utils/notification_helper.dart';
import '../bloc/detail/resto_detail_bloc.dart';
import '../bloc/home/resto_list_bloc.dart';
import '../bloc/home/resto_list_event.dart';
import '../bloc/home/resto_list_state.dart';
import 'detail_restaurant.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();
  await notificationHelper.initNotif(flutterLocalNotificationsPlugin);
  await di.init();
  await SettingsSharedPreferences.init();
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  service.initializeIsolate();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_)=>di.locator<RestaurantListBloc>()),
        BlocProvider(create: (_)=>di.locator<RestaurantDetailBloc>()),
        BlocProvider(create: (_)=>di.locator<RestaurantFavBloc>()),
        BlocProvider(create: (_)=>NotificationBloc())
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const RestaurantHomePage(),
            '/detailScreen': (context) => DetailRestaurantPage(
                ModalRoute.of(context)?.settings.arguments as String
            ),
            '/favourite' : (context) => const FavouriteRestaurantPage(),
            '/settings' : (context) => const SettingsPage(),
          },
          navigatorKey: navigatorKey,
      ),
    );
  }
}

class RestaurantHomePage extends StatefulWidget {
  const RestaurantHomePage({super.key});

  @override
  State<RestaurantHomePage> createState() => _RestaurantHomePageState();
}

class _RestaurantHomePageState extends State<RestaurantHomePage> {
  final debouncer = Debouncer(milliseconds: 250);
  final NotificationHelper _notificationHelper = NotificationHelper();
  String query = "";

  @override
  void initState() {
    Future.microtask(
            () => context.read<RestaurantListBloc>().add(
            const RestaurantListSearchEvent()
        )
    );
    _notificationHelper.configureSelectNotificationSubject("/detailScreen");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Cari restoran untuk kamu...',
            ),
            cursorColor: Colors.black,
            onChanged: (restoQuery){
              query = restoQuery;
              debouncer.run(() {
                context.read<RestaurantListBloc>().add(
                    RestaurantListSearchQueryEvent(query: query)
                );
              });
            },
          ),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.only(
                  right: 24
              ),
              child: SizedBox(
                width: 40,
                height: 40,
                child: FittedBox(
                  child: FloatingActionButton(
                    onPressed: (){
                      Navigator.pushNamed(
                          context,
                          '/settings'
                      );
                    },
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 2,
                            color: Colors.white),
                        borderRadius: BorderRadius.circular(100)
                    ),
                    child: const Icon(
                        Icons.tune_rounded,
                        color: Colors.white
                    ),
                  ),
                ),
              )
          )
        ],
      ),
      body: Center(
        child: BlocBuilder<RestaurantListBloc,RestaurantListState>(
          builder: (context, state){
            if (state is RestaurantListLoading){
              return Center(
                child: Text(
                  "Please wait, loading...",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                ),
              );
            } else if (state is RestaurantListLoaded){
              return ListView.builder(
                  itemCount: state.data.length,
                  itemBuilder: (context, index) {
                    return RestaurantCard(
                        restaurant: state.data[index],
                        fromFav: false,
                    );
                  }
              );
            } else if (state is RestaurantListNoData){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Oh No...",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "We can't find the restaurant you're searching for...",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.normal,
                          fontSize: 16
                      ),
                    )
                  ],
                ),
              );
            } else if (state is RestaurantListError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Oh No...",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.msg,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.normal,
                          fontSize: 16
                      ),
                    )
                  ],
                ),
              );
            }
            else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Oh No...",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "It seems, there is an error...",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.normal,
                          fontSize: 16
                      ),
                    )
                  ],
                ),
              );
            }
          }
        )
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.pushNamed(
                context,
                "/favourite",
            );
          },
          child: const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue,
            child: Icon(
                Icons.favorite,
                color: Colors.white,
            )
          ),
      ),
    );
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }
}
