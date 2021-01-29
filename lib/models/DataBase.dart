import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'AuthUser.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async{
    if(_database != null)
      return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async{
    return await openDatabase(
      join(await getDatabasesPath() , 'userData'),
      onCreate: (db , version) async {
        await db.execute('''
      CREATE TABLE users(
      email TEXT  , password TEXT , token TEXT , expiryDate TEXT , userId TEXT 
      )
      ''');
      },
      version: 1,
    );

  }

  newUser(UserAuth newUser) async{
    final db = await database;

    var res = await db.rawInsert('''
    INSERT INTO users (
    email , password , token , expiryDate , userId
    ) VALUES(? , ? , ? , ? , ?)
    ''' , [newUser.email , newUser.password , newUser.token , newUser.expiryDate , newUser.userId]);
    return res;
  }

  Future<dynamic> getUsers() async{

    final db = await database;
    var res = await db.query("users");
    if(res.length ==0 ){
      return null;
    }else{
      var resMap = res[0];
      return resMap.isNotEmpty ? resMap : null;
    }
  }

  dropTable(String id) async{
    final db = await database;
    await db.delete(
      'users',
      // Use a `where` clause to delete a specific dog.
      where: "userId = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}