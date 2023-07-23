import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant_app/presentation/bloc/favourite/resto_fav_bloc.dart';
import 'package:flutter_restaurant_app/presentation/bloc/favourite/resto_fav_event.dart';
import 'package:flutter_restaurant_app/presentation/bloc/favourite/resto_fav_state.dart';
import 'package:flutter_restaurant_app/presentation/widget/restaurant_card.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/utils/notification_helper.dart';


class FavouriteRestaurantPage extends StatefulWidget {
  const FavouriteRestaurantPage({super.key});

  @override
  State<FavouriteRestaurantPage> createState() => _FavouriteRestaurantPageState();
}

class _FavouriteRestaurantPageState extends State<FavouriteRestaurantPage> {

  @override
  void initState() {
    Future.microtask(
            () => context.read<RestaurantFavBloc>().add(
            const RestaurantFavSearchEvent()
        )
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            "Favourited Restaurant"
          )
        ),
      ),
      body: Center(
          child: BlocBuilder<RestaurantFavBloc,RestaurantFavState>(
              builder: (context, state){
                if (state is RestaurantFavLoading){
                  return Center(
                    child: Text(
                      "Please wait, loading...",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                      ),
                    ),
                  );
                } else if (state is RestaurantFavLoaded){
                  return ListView.builder(
                      itemCount: state.data.length,
                      itemBuilder: (context, index) {
                        return RestaurantCard(
                            restaurant: state.data[index],
                            fromFav: true
                        );
                      }
                  );
                } else if (state is RestaurantFavNoData){
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              "You're still not favourited any of the restaurant yet... ",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                              ),
                            ),
                        )
                      ],
                    ),
                  );
                } else if (state is RestaurantFavError) {
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
    );
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }
}