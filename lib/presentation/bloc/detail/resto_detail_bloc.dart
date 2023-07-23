import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant_app/presentation/bloc/detail/resto_detail_event.dart';
import 'package:flutter_restaurant_app/presentation/bloc/detail/resto_detail_state.dart';

import '../../../domain/repository/repository.dart';

class RestaurantDetailBloc extends Bloc<RestaurantDetailEvent, RestaurantDetailState>{
  final Repository repository;

  RestaurantDetailBloc({required this.repository}) : super(RestaurantDetailInit()){
    on<RestaurantDetailSearchEvent>((event,emit) async {
      emit(RestaurantDetailLoading());
      final restaurantDetail = await repository.getRestaurantDetail(
          event.restaurantId
      );
      restaurantDetail.fold(
              (l) => emit(RestaurantDetailError(l.message)),
              (r) => emit(RestaurantDetailLoaded(data: r))
      );
    });
  }
}