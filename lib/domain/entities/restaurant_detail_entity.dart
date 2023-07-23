import 'package:equatable/equatable.dart';

class RestaurantDetailEntity extends Equatable{
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureUrl;
  final List<String> categories;
  final List<String> foods;
  final List<String> drinks;
  final double rating;
  final List<String> customerReviewerName;
  final List<String> customerReview;
  final List<String> customerReviewDate;

  const RestaurantDetailEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureUrl,
    required this.categories,
    required this.rating,
    required this.foods,
    required this.drinks,
    required this.customerReviewerName,
    required this.customerReview,
    required this.customerReviewDate,
  });

  @override
  List<Object?> get props =>  [
    id, name, description,
    city, address, pictureUrl, categories,
    foods, drinks, rating,
    customerReview, customerReviewDate, customerReviewerName
  ];
}