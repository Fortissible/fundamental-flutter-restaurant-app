import 'package:equatable/equatable.dart';

abstract class RestaurantDetailEvent extends Equatable{
  const RestaurantDetailEvent();

  @override
  List<Object> get props => [];
}

class RestaurantDetailSearchEvent extends RestaurantDetailEvent{
  final String restaurantId;

  const RestaurantDetailSearchEvent({required this.restaurantId});

  @override
  List<Object> get props => [restaurantId];
}
