import 'package:equatable/equatable.dart';
import 'package:flutter_restaurant_app/domain/entities/restaurant_detail_entity.dart';

abstract class RestaurantDetailState extends Equatable{
  const RestaurantDetailState();

  @override
  List<Object> get props => [];
}

class RestaurantDetailInit extends RestaurantDetailState{}

class RestaurantDetailLoading extends RestaurantDetailState{}

class RestaurantDetailLoaded extends RestaurantDetailState{
  final RestaurantDetailEntity data;

  const RestaurantDetailLoaded({required this.data});

  @override
  List<Object> get props => [data];
}

class RestaurantDetailNoData extends RestaurantDetailState{
  final String msg;

  const RestaurantDetailNoData(this.msg);

  @override
  List<Object> get props => [];
}

class RestaurantDetailError extends RestaurantDetailState{
  final String msg;

  const RestaurantDetailError(this.msg);

  @override
  List<Object> get props => [];
}