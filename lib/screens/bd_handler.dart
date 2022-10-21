import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite/utils/string.dart';
import 'notes.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

class DBHelper{

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
    String path = join(documentDirectory.path, 'notes.db');
    var db = await openDatabase(path,version: 1,onCreate: _onCreate);
    return db;

  }
  _onCreate(Database db, int version)async{
    await db.execute(
      "CREATE TABLE notes (id INTEGER PRIMARY KEY AUTOINCREMENT, userid TEXT NOT NULL,title TEXT NOT NULL,   description TEXT NOT NULL)",
    );
  }

  Future<NotesModel> insert(NotesModel notesModel)async{
    var dbClient = await db;
    await dbClient!.insert('notes', notesModel.toMap());
    return notesModel;
  }

  Future<List<NotesModel>> getNotesList() async{
    final prefs = await SharedPreferences.getInstance();
    var gmail1=  prefs.getString(Strings.TagOfEmail);
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult = await dbClient!.query('notes',where: 'userid = ?',whereArgs: [gmail1]);
    print(queryResult);

    return queryResult.map((e) => NotesModel.fromMap(e)).toList();
  }

  Future<int> delete(int id)async{
    var dbClient = await db;
    return await dbClient!.delete('notes',
    where: 'id = ?',
      whereArgs: [id]
    );
  }

  Future<int> deleteForever()async{
    var list = await getNotesList();
    var dbClient = await db;
    for(var element  in list){
      await dbClient!.delete('notes',where: 'id = ?',whereArgs: [element.id]);
    }
    return 1;
  }

  Future<int> update(NotesModel notesModel)async{
    var dbClient = await db;
    return await dbClient!.update('notes',
      notesModel.toMap(),
      where: 'id = ?',
      whereArgs: [notesModel.id]
    );
  }

}