// To parse this JSON data, do
//
//     final restaurantSearchResponse = restaurantSearchResponseFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_restaurant_app/data/model/restaurant_model.dart';

class RestaurantSearchResponse extends Equatable{
  final bool error;
  final int founded;
  final List<RestaurantModel> restaurants;

  const RestaurantSearchResponse({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  factory RestaurantSearchResponse.fromRawJson(String str) => RestaurantSearchResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RestaurantSearchResponse.fromJson(Map<String, dynamic> json) => RestaurantSearchResponse(
    error: json["error"],
    founded: json["founded"],
    restaurants: List<RestaurantModel>.from(json["restaurants"].map((x) => RestaurantModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "founded": founded,
    "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
  };

  @override
  List<Object?> get props => [error, founded, restaurants];
}

class Restaurant {
  String id;
  String name;
  String description;
  String pictureId;
  String city;
  double rating;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory Restaurant.fromRawJson(String str) => Restaurant.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    pictureId: json["pictureId"],
    city: json["city"],
    rating: json["rating"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "pictureId": pictureId,
    "city": city,
    "rating": rating,
  };
}