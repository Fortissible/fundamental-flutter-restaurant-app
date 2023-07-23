import 'package:dio/dio.dart';
import 'package:flutter_restaurant_app/data/local_data_source/restaurant_db_impl.dart';
import 'package:flutter_restaurant_app/data/remote_data_source/remote_data_source.dart';
import 'package:flutter_restaurant_app/domain/repository/repository.dart';
import 'package:flutter_restaurant_app/presentation/bloc/favourite/resto_fav_bloc.dart';
import 'package:get_it/get_it.dart';

import '../data/repository/repository_impl.dart';
import '../presentation/bloc/detail/resto_detail_bloc.dart';
import '../presentation/bloc/home/resto_list_bloc.dart';
final locator = GetIt.instance;
Future<void> init() async {

  locator.registerFactory<RestaurantListBloc>(
          () => RestaurantListBloc(repository: locator())
  );
  locator.registerFactory<RestaurantDetailBloc>(
          () => RestaurantDetailBloc(repository: locator())
  );
  locator.registerFactory<RestaurantFavBloc>(
          () => RestaurantFavBloc(repository: locator())
  );

  locator.registerLazySingleton<Repository>(
          () => RepositoryImpl(
              remoteDataSource: locator(),
              restaurantDbImpl: locator()
          )
  );

  locator.registerLazySingleton<RemoteDataSource>(
          () => RemoteDataSourceImpl(dio: locator())
  );

  // external
  locator.registerLazySingleton(
          () => Dio()
  );
  locator.registerLazySingleton<RestaurantDbImpl>(
          () => RestaurantDbImpl()
  );
}