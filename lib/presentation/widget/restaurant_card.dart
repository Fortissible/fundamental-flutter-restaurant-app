import 'package:flutter/material.dart';

import '../../domain/entities/restaurant_entity.dart';

class RestaurantCard extends StatelessWidget{
  final RestaurantEntity restaurant;
  final bool fromFav;

  const RestaurantCard({
    required this.restaurant,
    required this.fromFav
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              leading: Container(
                width: 128,
                height: 150,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  child: Image.network(
                    restaurant.pictureUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                  restaurant.name
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  Text(
                      "Location : ${restaurant.city}"
                  ),
                  Text(
                      "Rating : ${restaurant.rating}"
                  ),
                ],
              )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: const Text('Check details'),
                onPressed: () {
                  Navigator.pushNamed(
                      context,
                      "/detailScreen",
                      arguments: restaurant.id
                  );
                },
              ),
              const SizedBox(width: 8),
              TextButton(
                child: const Text('Book restaurant'),
                onPressed: () {/* ... */},
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}