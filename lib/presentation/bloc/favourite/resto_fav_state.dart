import 'package:equatable/equatable.dart';
import 'package:flutter_restaurant_app/domain/entities/restaurant_entity.dart';

abstract class RestaurantFavState extends Equatable{
  const RestaurantFavState();

  @override
  List<Object> get props => [];
}

class RestaurantFavInit extends RestaurantFavState{}

class RestaurantFavLoading extends RestaurantFavState{}

class RestaurantFavLoaded extends RestaurantFavState{
  final List<RestaurantEntity> data;

  const RestaurantFavLoaded({required this.data});

  @override
  List<Object> get props => [data];
}

class RestaurantFavNoData extends RestaurantFavState{
  final String msg;

  const RestaurantFavNoData(this.msg);

  @override
  List<Object> get props => [];
}

class RestaurantFavError extends RestaurantFavState{
  final String msg;

  const RestaurantFavError(this.msg);

  @override
  List<Object> get props => [];
}


class RestaurantFavDoneState extends RestaurantFavState{
  final String msg;

  const RestaurantFavDoneState(this.msg);

  @override
  List<Object> get props => [msg];
}

class RestaurantFavErrorState extends RestaurantFavState{
  final String msg;

  const RestaurantFavErrorState(this.msg);

  @override
  List<Object> get props => [msg];
}

class RestaurantFavBoolState extends RestaurantFavState{
  final bool isFavourited;

  const RestaurantFavBoolState(this.isFavourited);

  @override
  List<Object> get props => [isFavourited];
}