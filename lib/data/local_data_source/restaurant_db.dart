import 'package:flutter_restaurant_app/domain/entities/restaurant_detail_entity.dart';
import 'package:flutter_restaurant_app/domain/entities/restaurant_entity.dart';

abstract class RestaurantDb {
  Future<List<RestaurantEntity>> getAllFavRestaurant();
  Future<void> insertFavRestaurant(
      RestaurantEntity restaurantEntity
      );
  Future<void> deleteFavRestaurant(
      String id
      );
  Future<bool> isRestaurantFavourited(
      String id
      );
}