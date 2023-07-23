import 'package:equatable/equatable.dart';

import '../../../domain/entities/restaurant_entity.dart';

abstract class RestaurantFavEvent extends Equatable{
  const RestaurantFavEvent();

  @override
  List<Object> get props => [];
}

class RestaurantFavSearchEvent extends RestaurantFavEvent{
  const RestaurantFavSearchEvent();

  @override
  List<Object> get props => [];
}


class RestaurantInsertFavEvent extends RestaurantFavEvent{
  final RestaurantEntity restaurantEntity;

  const RestaurantInsertFavEvent({required this.restaurantEntity});

  @override
  List<Object> get props => [restaurantEntity];
}

class RestaurantDeleteFavEvent extends RestaurantFavEvent{
  final String id;

  const RestaurantDeleteFavEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class RestaurantCheckFavEvent extends RestaurantFavEvent{
  final String id;

  const RestaurantCheckFavEvent({required this.id});

  @override
  List<Object> get props => [id];
}