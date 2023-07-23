// To parse this JSON data, do
//
//     final restaurantListResponse = restaurantListResponseFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../model/restaurant_model.dart';

class RestaurantListResponse extends Equatable{
  final bool error;
  final String message;
  final  int count;
  final  List<RestaurantModel> restaurants;

  const RestaurantListResponse({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  factory RestaurantListResponse.fromRawJson(String str) => RestaurantListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RestaurantListResponse.fromJson(Map<String, dynamic> json) => RestaurantListResponse(
    error: json["error"],
    message: json["message"],
    count: json["count"],
    restaurants: List<RestaurantModel>.from(json["restaurants"].map((x) =>
        RestaurantModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "count": count,
    "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
  };

  @override
  List<Object?> get props => [error, message, count, restaurants];
}
