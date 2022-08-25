import 'package:sqflite/sqflite.dart';
import 'package:task2/models/task_model.dart';

class DbService {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'Tasks';

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + 'Tasks.db';
      _db = await openDatabase(_path, version: _version, onCreate: (db, version) {
        //   print("creating a new one ");
        return db.execute(
          "CREATE TABLE $_tableName("
          "id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "title STRING, note TEXT, date STRING, "
          "startTime STRING, endTime STRING, "
          "remind INTEGER, repeat STRING, "
          "color INTEGER, "
          "isCompelet INTEGER)",
        );
      });
    } catch (e) {
      //  print(e);
    }
  }

  static Future<int> insert(TaskModel? task) async {
    return await _db?.insert(_tableName, task!.toJason()) ?? 1;
  } 

  static delete(TaskModel task) async {
    await _db!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    return _db!.query(_tableName);
  }

  static update(int id) async{
   return await _db!.rawUpdate(''' 
    UPDATE Tasks 
    SET isCompelet = ?
    WHERE ID = ?
  ''' , [1,id]);
  }
}
