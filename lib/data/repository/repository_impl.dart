import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_restaurant_app/core/failure/exception.dart';
import 'package:flutter_restaurant_app/data/local_data_source/restaurant_db_impl.dart';
import 'package:flutter_restaurant_app/data/remote_data_source/remote_data_source.dart';
import 'package:flutter_restaurant_app/domain/entities/restaurant_detail_entity.dart';
import 'package:flutter_restaurant_app/domain/entities/restaurant_entity.dart';
import 'package:flutter_restaurant_app/domain/repository/repository.dart';
import '../../core/failure/failure.dart';

class RepositoryImpl implements Repository{
  final RemoteDataSource remoteDataSource;
  final RestaurantDbImpl restaurantDbImpl;

  const RepositoryImpl({
    required this.remoteDataSource,
    required this.restaurantDbImpl
  });

  @override
  Future<Either<Failure, List<RestaurantEntity>>> getListRestaurant() async {
    try {
      final restaurantListData = await remoteDataSource.getRestaurantList();
      final restaurantListEntity = restaurantListData.map(
              (restaurantEntity) => restaurantEntity.modelToEntity()
      ).toList();
      return Right(restaurantListEntity);
    } on SocketException catch (e){
      return Left(ConnectionFailure(e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, RestaurantDetailEntity>> getRestaurantDetail(
      String id
      ) async {
    try {
      final restaurantDetailData = await remoteDataSource.getRestaurantDetail(id);
      final restaurantDetailEntity = restaurantDetailData.modelToEntity();
      return Right(restaurantDetailEntity);
    } on SocketException catch (e){
      return Left(ConnectionFailure(e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RestaurantEntity>>> searchRestaurant(String query)
    async{
      try {
        final restaurantListData = await remoteDataSource.searchRestaurant(query);
        final restaurantListEntity = restaurantListData.map(
                (restaurantEntity) => restaurantEntity.modelToEntity()
        ).toList();
        return Right(restaurantListEntity);
      } on SocketException catch (e){
        return Left(ConnectionFailure(e.message.toString()));
      }
  }

  @override
  Future<Either<Failure, String>> deleteFavRestaurant(String id) async {
    try {
      await restaurantDbImpl.deleteFavRestaurant(id);
      return const Right("Success delete from favourite restaurant");
    } on DatabaseException{
      return const Left(DatabaseFailure("Database error"));
    }
  }

  @override
  Future<Either<Failure, List<RestaurantEntity>>> getAllFavRestaurant() async {
    try {
      final listRestaurant = await restaurantDbImpl.getAllFavRestaurant();
      return Right(listRestaurant);
    } on DatabaseException{
      return const Left(DatabaseFailure("Database error"));
    }
  }

  @override
  Future<Either<Failure, String>> insertFavRestaurant(
      RestaurantEntity restaurantEntity) async {
    try {
      await restaurantDbImpl.insertFavRestaurant(restaurantEntity);
      return const Right("Success added a favourite restaurant");
    } on DatabaseException{
      return const Left(DatabaseFailure("Database error"));
    }
  }

  @override
  Future<Either<Failure, bool>> checkFavourited(String id) async {
    try {
      final result = await restaurantDbImpl.isRestaurantFavourited(id);
      return Right(result);
    } on DatabaseException{
      return const Left(DatabaseFailure("Database error"));
    }
  }
}