import 'package:equatable/equatable.dart';

abstract class RestaurantListEvent extends Equatable{
  const RestaurantListEvent();

  @override
  List<Object> get props => [];
}

class RestaurantListSearchEvent extends RestaurantListEvent{
  const RestaurantListSearchEvent();

  @override
  List<Object> get props => [];
}

class RestaurantListSearchQueryEvent extends RestaurantListEvent{
  final String query;

  const RestaurantListSearchQueryEvent({required this.query});

  @override
  List<Object> get props => [query];
}
