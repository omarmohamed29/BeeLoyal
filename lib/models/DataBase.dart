import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

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
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'userData.db');
    return await openDatabase(path , version: 1,
      onCreate: (db , version) async {
        await db.execute(''' CREATE TABLE users(id TEXT , theme TEXT ) ''');
      },

    );

  }

  setTheme(String theme) async{
    final db = await database;

    var res = await db.rawInsert('''
    INSERT INTO users (
    id ,theme 
    ) VALUES(? , ?)
    ''' , ['1', theme ]);
    print(res);
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

  update(String theme) async{
    final db = await database;
    var databasesPath = await getDatabasesPath();
    print(databasesPath );
    int count = await db.rawUpdate(
        'UPDATE users SET theme = ? WHERE id = ?',
        [theme, '1',]);

    print('updated: $count');
  }

  printDB()async{
    final db = await database;
    final tables = await db.rawQuery('SELECT * FROM users ;');
    print(tables);
  }

  dropTable(String id) async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'userData.db');
    await deleteDatabase(path);
  }
}