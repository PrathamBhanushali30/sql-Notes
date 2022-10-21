import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite/screens/users.dart';

class UserDBHelper{
static Database? _db;

Future<Database?> get db async{
  if(_db != null){
    return _db;
  }
    _db = await initDatabase();
    return _db;
}

initDatabase()async{
  io.Directory documentDirectory = await getApplicationDocumentsDirectory();
  String path = join(documentDirectory.path,'user.db');
  var db = await openDatabase(path,version: 1,onCreate: _onCreate);
  return db;
}
_onCreate(Database db, int version)async{
  await db.execute(
    "CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, fName TEXT NOT NULL, lName TEXT NOT NULL, mob TEXT NOT NULL, eMail TEXT NOT NULL, city TEXT NOT NULL, password TEXT NOT NULL)"
  );
}

Future<UserModel> insert(UserModel userModel)async{
  var dbClient = await db;
  await dbClient!.insert('users', userModel.toMap());
  return userModel;
}

Future<List<UserModel>> getUsersList() async{
  var dbClient = await db;
  final List<Map<String, Object?>> queryResult =
      await dbClient!.query('users');
  return queryResult.map((e) => UserModel.fromMap(e)).toList();
 // return await dbClient!.delete('users',where: 'id = ?', whereArgs: [id]);
}

Future<int> delete(int id) async{
  var dbClient = await db;
  return  dbClient!.delete('users',where: 'id = ?', whereArgs: [id]);
}

}