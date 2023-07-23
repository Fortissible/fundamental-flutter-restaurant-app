import 'package:flutter_restaurant_app/data/local_data_source/restaurant_db.dart';
import 'package:flutter_restaurant_app/domain/entities/restaurant_entity.dart';
import 'package:sqflite/sqflite.dart';

class RestaurantDbImpl implements RestaurantDb{
  final String _tableName = 'restaurant';

  static RestaurantDbImpl? _restaurantDbImpl;
  RestaurantDbImpl._instance(){
    _restaurantDbImpl = this;
  }
  factory RestaurantDbImpl() => _restaurantDbImpl ??
      RestaurantDbImpl._instance();

  static late Database _database;

  Future<Database> get database async {
    _database = await _initDb();
    return _database;
  }

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final db = openDatabase(
        "$path/restaurant_db.db",
        version: 1,
        onCreate: (db, version) async {
          await db.execute(
            '''
            CREATE TABLE $_tableName(
            id TEXT PRIMARY KEY,
            name TEXT,
            description TEXT,
            pictureUrl TEXT,
            city TEXT,
            rating REAL
            )
            '''
          );
        }
    );
    return db;
  }

  @override
  Future<void> deleteFavRestaurant(String id) async {
    final Database db = await database;
    db.delete(
        _tableName,
        where: "id = ?",
        whereArgs: [id]
    );
  }

  @override
  Future<List<RestaurantEntity>> getAllFavRestaurant() async {
    final Database db = await database;
    List<Map<String, dynamic>> restaurantMapList = await db.query(_tableName);
    final listRestaurantEntity = restaurantMapList.map(
            (restaurantMap) => RestaurantEntity.fromMap(restaurantMap)
    ).toList();
    return listRestaurantEntity;
  }

  @override
  Future<void> insertFavRestaurant(RestaurantEntity restaurantEntity) async {
    final Database db = await database;
    final restaurantMap = restaurantEntity.entityToMap();
    await db.insert(_tableName, restaurantMap);
  }

  @override
  Future<bool> isRestaurantFavourited (String id) async{
    final Database db = await database;
    final checkData = await db.query(_tableName,where: "id = ?", whereArgs: [id]);
    if (checkData.isEmpty){
      return true;
    } else {
      return false;
    }
  }
}