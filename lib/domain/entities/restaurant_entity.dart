import 'package:equatable/equatable.dart';

class RestaurantEntity extends Equatable{
  final String id;
  final String name;
  final String description;
  final String pictureUrl;
  final String city;
  final double rating;

  const RestaurantEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureUrl,
    required this.city,
    required this.rating,
  });

  Map<String, dynamic> entityToMap(){
    return {
      'id': id,
      'name': name,
      'description': description,
      'pictureUrl': pictureUrl,
      'city': city,
      'rating': rating,
    };
  }

  factory RestaurantEntity.fromMap(Map<String, dynamic> map) => RestaurantEntity(
      id: map["id"],
      name: map["name"],
      description: map["description"],
      pictureUrl: map["pictureUrl"],
      city: map["city"],
      rating: map["rating"]
  );

  @override
  List<Object?> get props => [id, name, description, pictureUrl, city, rating];
}