
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_restaurant_app/data/model/restaurant_detail_model.dart';
import 'package:flutter_restaurant_app/data/response/restaurant_detail_response.dart';
import 'package:flutter_restaurant_app/data/response/restaurant_search_response.dart';

import '../../core/failure/exception.dart';
import '../model/restaurant_model.dart';
import '../response/restaurant_list_response.dart';

abstract class RemoteDataSource {
  Future<List<RestaurantModel>> getRestaurantList();
  Future<RestaurantDetailModel> getRestaurantDetail(String id);
  Future<List<RestaurantModel>> searchRestaurant(String query);
}

class RemoteDataSourceImpl implements RemoteDataSource{
  static const baseUrl = "https://restaurant-api.dicoding.dev";

  static const endPointRestaurantListUrl = "/list";
  static const endPointDetailUrl = "/detail/";
  static const endPointSearchUrl = "/search?q=";
  static const endPointPostReviewUrl = "/review";

  final Dio dio;

  RemoteDataSourceImpl({required this.dio});

  @override
  Future<List<RestaurantModel>> getRestaurantList() async {
    try {
      final listRestaurantResponse = await dio.get(
          baseUrl+endPointRestaurantListUrl
      );
      if (listRestaurantResponse.statusCode == 200){
        return RestaurantListResponse.fromJson(listRestaurantResponse.data)
            .restaurants;
      } else {
        throw ServerException();
      }
    } on DioException {
      throw const SocketException("Connection problem!");
    }
  }

  @override
  Future<RestaurantDetailModel> getRestaurantDetail(String id) async {
    try {
      final restaurantDetailResponse = await dio.get(
          baseUrl+endPointDetailUrl+id
      );
      if (restaurantDetailResponse.statusCode == 200){
        return RestaurantDetailResponse.fromJson(restaurantDetailResponse.data)
            .restaurant;
      } else {
        throw ServerException();
      }
    } on DioException {
      throw const SocketException("Connection problem!");
    }
  }

  @override
  Future<List<RestaurantModel>> searchRestaurant(String query) async {
    try {
      final listRestaurantResponse = await dio.get(
          baseUrl+endPointSearchUrl+query
      );
      if (listRestaurantResponse.statusCode == 200){
        return RestaurantSearchResponse.fromJson(listRestaurantResponse.data)
            .restaurants;
      } else {
        throw ServerException();
      }
    } on DioException {
      throw const SocketException("Connection problem!");
    }
  }
}