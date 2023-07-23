import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant_app/presentation/bloc/favourite/resto_fav_event.dart';
import 'package:flutter_restaurant_app/presentation/bloc/favourite/resto_fav_state.dart';

import '../../../domain/repository/repository.dart';

class RestaurantFavBloc extends Bloc<RestaurantFavEvent, RestaurantFavState>{
  final Repository repository;

  RestaurantFavBloc({required this.repository}) : super(RestaurantFavInit()){

    on<RestaurantFavSearchEvent>((event,emit) async {
      emit(RestaurantFavLoading());
      final restaurantList = await repository.getAllFavRestaurant();
      restaurantList.fold(
              (l) => emit(RestaurantFavError(l.message)),
              (r) {
                if (r.isNotEmpty) {
                  emit(RestaurantFavLoaded(data: r));
                } else if (r.isEmpty){
                  emit(const RestaurantFavNoData(
                      "No Favourited Restaurant Yet"
                  ));
                }
              }
      );
    });

    on<RestaurantInsertFavEvent>((event,emit) async {
      final result = await repository.insertFavRestaurant(event.restaurantEntity);
      result.fold(
              (l) => emit(RestaurantFavErrorState(l.message)),
              (r) => emit(RestaurantFavDoneState(r))
      );
    });

    on<RestaurantDeleteFavEvent>((event,emit) async {
      final result = await repository.deleteFavRestaurant(event.id);
      result.fold(
              (l) => emit(RestaurantFavErrorState(l.message)),
              (r) => emit(RestaurantFavDoneState(r))
      );
    });

    on<RestaurantCheckFavEvent>((event,emit) async {
      final result = await repository.checkFavourited(event.id);
      result.fold(
              (l) => emit(RestaurantFavErrorState(l.message)),
              (r) => emit(RestaurantFavBoolState(r))
      );
    });
  }
}