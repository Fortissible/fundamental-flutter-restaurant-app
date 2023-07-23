import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant_app/presentation/bloc/home/resto_list_event.dart';
import 'package:flutter_restaurant_app/presentation/bloc/home/resto_list_state.dart';

import '../../../domain/repository/repository.dart';

class RestaurantListBloc extends Bloc<RestaurantListEvent, RestaurantListState>{
  final Repository repository;

  RestaurantListBloc({required this.repository}) : super(RestaurantListInit()){
    on<RestaurantListSearchEvent>((event,emit) async {
      emit(RestaurantListLoading());
      final restaurantList = await repository.getListRestaurant();
      restaurantList.fold(
              (l) => emit(RestaurantListError(l.message)),
              (r) => {
                if (r.isNotEmpty) {
                  emit(RestaurantListLoaded(data: r))
                } else if (r.isEmpty){
                  emit(const RestaurantListNoData("No data found"))
                }
              }
      );
    });

    on<RestaurantListSearchQueryEvent>((event,emit) async {
      emit(RestaurantListLoading());
      final restaurantList = await repository.searchRestaurant(event.query);
      restaurantList.fold(
              (l) => emit(RestaurantListError(l.message)),
              (r) => {
            if (r.isNotEmpty) {
              emit(RestaurantListLoaded(data: r))
            } else if (r.isEmpty){
              emit(const RestaurantListNoData("No data found"))
            }
          }
      );
    });
  }
}