import 'package:flutter_restaurant_app/data/remote_data_source/remote_data_source.dart';
import 'package:flutter_restaurant_app/domain/entities/restaurant_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';

class MockRestaurantRemoteDataSource extends Mock implements RemoteDataSource{}
class MockDio extends Mock implements Dio{}

void main(){
  late MockDio mockDio;
  late RemoteDataSourceImpl service;

  setUp((){
    mockDio = MockDio();
    service = RemoteDataSourceImpl(dio: mockDio);
  });

  group("Fetch API and Parse Restaurant API Response JSON", (){
    final Response successResponse = Response(
      statusCode: 200,
      data: {
        "error": false,
        "message": "success",
        "count": 20,
        "restaurants": [
          {
            "id": "rqdv5juczeskfw1e867",
            "name": "Melting Pot",
            "description": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
            "pictureId": "14",
            "city": "Medan",
            "rating": 4.2
          },
          {
            "id": "s1knt6za9kkfw1e867",
            "name": "Kafe Kita",
            "description": "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. ...",
            "pictureId": "25",
            "city": "Gorontalo",
            "rating": 4
          }
        ]
      },
      requestOptions: RequestOptions(path: '<https://restaurant-api.dicoding.dev/list>'),
    );

    final Response failedResponse = Response(
        statusCode: 404,
        requestOptions: RequestOptions(path: '<https://restaurant-api.dicoding.dev/list>'),
        statusMessage: "Some error happened!"
    );

    test(
        "Success Fetch and Parse Restaurant Response JSON", () async {
      when(() => mockDio.get("https://restaurant-api.dicoding.dev/list"))
          .thenAnswer((_) async => Future.value(successResponse)
      );
      final response = await service.getRestaurantList();
      final restaurantEntityList = response.map((restaurantModel) =>
          restaurantModel.modelToEntity()).toList();
      expect( restaurantEntityList,
          equals(
              [
                const RestaurantEntity(
                    id: "rqdv5juczeskfw1e867",
                    name: "Melting Pot",
                    description: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
                    pictureUrl: "https://restaurant-api.dicoding.dev/images/small/14",
                    city: "Medan",
                    rating: 4.2
                ),
                const RestaurantEntity(
                    id: "s1knt6za9kkfw1e867",
                    name: "Kafe Kita",
                    description: "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. ...",
                    pictureUrl: "https://restaurant-api.dicoding.dev/images/small/25",
                    city: "Gorontalo",
                    rating: 4
                )
              ]
          ));
    }
    );

    test(
        "Error Fetch Restaurant API and Throw exception", () async {
      when(()=> mockDio.get("https://restaurant-api.dicoding.dev/list"))
          .thenAnswer((_) async => Future.value(failedResponse));
      expect(service.getRestaurantList(), throwsException);
    }
    );
  });
}