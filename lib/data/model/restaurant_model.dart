import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../domain/entities/restaurant_entity.dart';

class RestaurantModel extends Equatable{
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;

  const RestaurantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory RestaurantModel.fromRawJson(String str) => RestaurantModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RestaurantModel.fromJson(Map<String, dynamic> json) => RestaurantModel(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    pictureId: json["pictureId"],
    city: json["city"],
    rating: json["rating"]?.toDouble(),
  );

  RestaurantEntity modelToEntity() => RestaurantEntity(
      id: id,
      name: name,
      description: description,
      pictureUrl: "https://restaurant-api.dicoding.dev/images/small/${pictureId.toString()}",
      city: city,
      rating: rating
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "pictureId": pictureId,
    "city": city,
    "rating": rating,
  };

  @override
  List<Object?> get props => [id, name, description, pictureId, city, rating];
}