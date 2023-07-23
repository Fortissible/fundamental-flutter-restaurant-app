import 'package:equatable/equatable.dart';
import 'package:flutter_restaurant_app/domain/entities/restaurant_entity.dart';

abstract class RestaurantListState extends Equatable{
  const RestaurantListState();

  @override
  List<Object> get props => [];
}

class RestaurantListInit extends RestaurantListState{}

class RestaurantListLoading extends RestaurantListState{}

class RestaurantListLoaded extends RestaurantListState{
  final List<RestaurantEntity> data;

  const RestaurantListLoaded({required this.data});

  @override
  List<Object> get props => [data];
}

class RestaurantListNoData extends RestaurantListState{
  final String msg;

  const RestaurantListNoData(this.msg);

  @override
  List<Object> get props => [];
}

class RestaurantListError extends RestaurantListState{
  final String msg;

  const RestaurantListError(this.msg);

  @override
  List<Object> get props => [];
}