import 'package:flutter_restaurant_app/domain/entities/restaurant_detail_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_restaurant_app/domain/entities/restaurant_entity.dart';
import '../../core/failure/failure.dart';
abstract class Repository {
  Future<Either<Failure, List<RestaurantEntity>>> getListRestaurant();
  Future<Either<Failure, List<RestaurantEntity>>> searchRestaurant(String query);
  Future<Either<Failure, RestaurantDetailEntity>> getRestaurantDetail(String id);

  Future<Either<Failure, List<RestaurantEntity>>> getAllFavRestaurant();
  Future<Either<Failure, String>> insertFavRestaurant(RestaurantEntity restaurantEntity);
  Future<Either<Failure, String>> deleteFavRestaurant(String id);
  Future<Either<Failure, bool>> checkFavourited(String id);
}