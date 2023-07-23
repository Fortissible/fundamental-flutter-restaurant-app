import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_restaurant_app/domain/entities/restaurant_detail_entity.dart';

class RestaurantDetailModel extends Equatable{
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  final List<CategoryModel> categories;
  final  Menus menus;
  final double rating;
  final List<CustomerReviewModel> customerReviews;

  const RestaurantDetailModel({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.categories,
    required this.menus,
    required this.rating,
    required this.customerReviews,
  });

  factory RestaurantDetailModel.fromRawJson(String str) => RestaurantDetailModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RestaurantDetailModel.fromJson(Map<String, dynamic> json) => RestaurantDetailModel(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    city: json["city"],
    address: json["address"],
    pictureId: json["pictureId"],
    categories: List<CategoryModel>.from(json["categories"].map((x) =>
        CategoryModel.fromJson(x))),
    menus: Menus.fromJson(json["menus"]),
    rating: json["rating"]?.toDouble(),
    customerReviews: List<CustomerReviewModel>.from(json["customerReviews"].map((x) =>
        CustomerReviewModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "city": city,
    "address": address,
    "pictureId": pictureId,
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
    "menus": menus.toJson(),
    "rating": rating,
    "customerReviews": List<dynamic>.from(customerReviews.map((x) => x.toJson())),
  };

  RestaurantDetailEntity modelToEntity() => RestaurantDetailEntity(
      id: id,
      name: name,
      description: description,
      city: city,
      address: address,
      pictureUrl: "https://restaurant-api.dicoding.dev/images/medium/${pictureId.toString()}",
      categories: categories.map((category) => category.name).toList(),
      rating: rating,
      foods: menus.foods.map((food) => food.name).toList(),
      drinks: menus.drinks.map((drink) => drink.name).toList(),
      customerReviewerName: customerReviews.map(
              (review) => review.name
      ).toList(),
      customerReview: customerReviews.map(
              (review) => review.review
      ).toList(),
      customerReviewDate: customerReviews.map(
              (review) => review.date
      ).toList()
  );

  @override
  List<Object?> get props =>  [
    id, name, description,
    city, address, pictureId, categories,
    menus, rating, customerReviews
  ];
}

class CategoryModel extends Equatable{
  final String name;

  const CategoryModel({
    required this.name,
  });

  factory CategoryModel.fromRawJson(String str) => CategoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };

  @override
  List<Object> get props => [name];
}

class CustomerReviewModel extends Equatable{
  final String name;
  final String review;
  final String date;

  const CustomerReviewModel({
    required this.name,
    required this.review,
    required this.date,
  });

  factory CustomerReviewModel.fromRawJson(String str) => CustomerReviewModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerReviewModel.fromJson(Map<String, dynamic> json) => CustomerReviewModel(
    name: json["name"],
    review: json["review"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "review": review,
    "date": date,
  };

  @override
  List<Object?> get props => [name, review, date];
}

class Menus extends Equatable{
  final List<CategoryModel> foods;
  final List<CategoryModel> drinks;

  const Menus({
    required this.foods,
    required this.drinks,
  });

  factory Menus.fromRawJson(String str) => Menus.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Menus.fromJson(Map<String, dynamic> json) => Menus(
    foods: List<CategoryModel>.from(json["foods"].map((x) => CategoryModel.fromJson(x))),
    drinks: List<CategoryModel>.from(json["drinks"].map((x) => CategoryModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
    "drinks": List<dynamic>.from(drinks.map((x) => x.toJson())),
  };

  @override
  List<Object?> get props => [foods, drinks];
}