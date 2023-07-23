import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant_app/domain/entities/restaurant_detail_entity.dart';
import 'package:flutter_restaurant_app/domain/entities/restaurant_entity.dart';
import 'package:flutter_restaurant_app/presentation/bloc/favourite/resto_fav_bloc.dart';
import 'package:flutter_restaurant_app/presentation/bloc/favourite/resto_fav_event.dart';
import 'package:flutter_restaurant_app/presentation/bloc/favourite/resto_fav_state.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/utils/notification_helper.dart';
import '../bloc/detail/resto_detail_bloc.dart';
import '../bloc/detail/resto_detail_event.dart';
import '../bloc/detail/resto_detail_state.dart';

class DetailRestaurantPage extends StatefulWidget{
  final String restaurantId;
  const DetailRestaurantPage(this.restaurantId, {super.key});

  @override
  State<DetailRestaurantPage> createState() => _DetailRestaurantPageState();
}

class _DetailRestaurantPageState extends State<DetailRestaurantPage> {

  late bool isFavourited;

  @override
  void initState() {
    Future.microtask(
            () {
              context.read<RestaurantDetailBloc>().add(
                  RestaurantDetailSearchEvent(
                      restaurantId: widget.restaurantId
                  )
              );
              context.read<RestaurantFavBloc>().add(
                  RestaurantCheckFavEvent(id: widget.restaurantId)
              );
            }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: BlocBuilder<RestaurantDetailBloc,RestaurantDetailState>(
            builder: (context,state) {
              if (state is RestaurantDetailLoading){
                return Scaffold(
                    appBar: AppBar(
                      title: const Text(
                          "Loading Your Restaurant"
                      ),
                    ),
                    body: Center(
                      child: Text(
                        "Please wait, loading...",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),
                      ),
                    )
                );
              }
              else if (state is RestaurantDetailLoaded){
                return Scaffold(
                  appBar: AppBar(
                    title: Text(
                        "${state.data.name} Restaurant"
                    ),
                  ),
                  body: ListView(
                    children: [
                      _buildRestaurantCardItem(context,state.data),
                      Container(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        width: MediaQuery.of(context).size.width,
                        child:const Text(
                          "Drinks Menu",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      _buildRestaurantCardMenuItem(context, state.data.drinks),
                      Container(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        width: MediaQuery.of(context).size.width,
                        child:const Text(
                          "Foods Menu",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      _buildRestaurantCardMenuItem(context, state.data.foods),
                    ],
                  ),
                );
              }
              else if (state is RestaurantDetailError){
                return Scaffold(
                  appBar: AppBar(
                    title: const Text(
                        "Error Getting Restaurant Detail"
                    ),
                  ),
                  body: Center(
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
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.normal,
                              fontSize: 16
                          ),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text(
                        "Error Getting Restaurant Detail"
                    ),
                  ),
                  body: Center(
                    child: Column(
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
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.normal,
                              fontSize: 16
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            }
        ),
        onWillPop: () async {
          context.read<RestaurantFavBloc>().add(
              const RestaurantFavSearchEvent()
          );
          return true;
        }
    );

  }

  Widget _buildRestaurantCardItem(BuildContext context, RestaurantDetailEntity restaurant){
    return Card(
      margin: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(32.0),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              child: Image.network(
                restaurant.pictureUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8, height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  restaurant.name,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                  ),
                ),
                BlocBuilder<RestaurantFavBloc,RestaurantFavState>(
                    builder: (context,state) {
                      if (state is RestaurantFavBoolState) {
                        if (!state.isFavourited) {
                          return CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.blue,
                            child: IconButton(
                                onPressed: (){
                                  context.read<RestaurantFavBloc>().add(
                                      RestaurantDeleteFavEvent(
                                          id: restaurant.id
                                      )
                                  );
                                  context.read<RestaurantFavBloc>().add(
                                      RestaurantCheckFavEvent(id: widget.restaurantId)
                                  );
                                },
                                hoverColor: Colors.lightBlue,
                                color: Colors.white,
                                icon: const Icon(
                                  Icons.favorite,
                                  color: Colors.pinkAccent,
                                )
                            ),
                          );
                        } else {
                          return CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.blue,
                            child: IconButton(
                                onPressed: (){
                                  context.read<RestaurantFavBloc>().add(
                                      RestaurantInsertFavEvent(
                                          restaurantEntity: RestaurantEntity(
                                              id: restaurant.id,
                                              name: restaurant.name,
                                              description: restaurant.description,
                                              pictureUrl: restaurant.pictureUrl,
                                              city: restaurant.city,
                                              rating: restaurant.rating
                                          )
                                      )
                                  );
                                  context.read<RestaurantFavBloc>().add(
                                      RestaurantCheckFavEvent(id: widget.restaurantId)
                                  );
                                },
                                hoverColor: Colors.lightBlue,
                                color: Colors.white,
                                icon: const Icon(
                                    Icons.favorite,
                                    color: Colors.white,
                                )
                            ),
                          );
                        }
                      }
                      else {
                        return const SizedBox();
                      }
                    }
                )
              ],
            ),
            const SizedBox(width: 8, height: 8,),
            Text(
              "Location   : ${restaurant.city}",
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            Text(
              "Rating       : ${restaurant.rating.toString()}",
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            const Divider(),
            Text(
              restaurant.description,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantCardMenuItem(BuildContext context, List<String> menus){
    return SizedBox(
      height: 120,
      width: MediaQuery.of(context).size.width,
      child : ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: menus.length,
        itemBuilder: (context, idx) => Card(
            margin: const EdgeInsets.only(left: 16, right: 8, top:8, bottom: 8),
            child: UnconstrainedBox(
              child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Row (
                    children: [
                      const Icon(
                          Icons.fastfood
                      ),
                      const SizedBox(width: 8, height: 8,),
                      Text(
                          menus[idx]
                      )
                    ],
                  )
              ),
            )
        )
      )
    );
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }
}
