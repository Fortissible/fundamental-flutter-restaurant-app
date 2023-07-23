// To parse this JSON data, do
//
//     final restaurantDetailResponse = restaurantDetailResponseFromJson(jsonString);

import 'dart:convert';

import '../model/restaurant_detail_model.dart';

class RestaurantDetailResponse {
  bool error;
  String message;
  RestaurantDetailModel restaurant;

  RestaurantDetailResponse({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  factory RestaurantDetailResponse.fromRawJson(String str) => RestaurantDetailResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RestaurantDetailResponse.fromJson(Map<String, dynamic> json) => RestaurantDetailResponse(
    error: json["error"],
    message: json["message"],
    restaurant: RestaurantDetailModel.fromJson(json["restaurant"]),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "restaurant": restaurant.toJson(),
  };
}