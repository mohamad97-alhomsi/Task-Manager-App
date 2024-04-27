import 'dart:developer';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:task_manager_app/services/storage_service/storage_constants.dart';

class StorageService {
  static Database? _db;

  static Future<Database> get getDatabase async {
    if (_db == null) {
      _db = await StorageService._initDatabase();
      return _db!;
    } else {
      return _db!;
    }
  }

  static Future<Database> _initDatabase() async {
    late Database db;
    if (Platform.isWindows || Platform.isLinux) {
      var folder = await getDownloadsDirectory();
      sqfliteFfiInit();
      log("Database path ${folder!.path}");
      var databaseFactory = databaseFactoryFfi;
      db = await databaseFactory.openDatabase(folder.path + '/database.db',
          options: OpenDatabaseOptions(
            version: 1,
            onCreate: _createDatabaseTables,
          ));
    }

    if (Platform.isAndroid || Platform.isIOS) {
      var folder = await getDatabasesPath();

      log("Database path ${folder}");
      db = await openDatabase(folder + "/android.db",
          version: 1, onCreate: _createDatabaseTables);
    }

    return db;
  }

  static Future<void> _createDatabaseTables(Database db, int version) async {
    await db.execute('''
          CREATE TABLE ${StorageConstants.tasksTable} (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          todo TEXT NOT NULL
          )
            ''');
    log("Table ${StorageConstants.tasksTable}, is Created");
  }

  static Future readFromDatabase(String tableName,
      {String? where, List<String>? whereArgs, List<String>? columns}) async {
    var data = await _db!.query(tableName,
        where: where == null ? null : '$where = ?',
        whereArgs: whereArgs,
        columns: columns);

    return data;
  }

  static Future insertToDatabase(
      String tableName, Map<String, Object?> data) async {
    int rowIndex =
        await _db!.insert(tableName, data).onError((error, stackTrace) {
      Logger().f(error);
      return -1;
    });
    Logger().w("Row Index in Table is $rowIndex with data $data");
    return rowIndex;
  }

  static Future deleteFromDatabase(String tableName,
      {String? where, List<String>? columns}) async {
    int rowIndex = await _db!.delete(tableName,
        where: where == null ? null : "$where= ?", whereArgs: columns);
    Logger().w("the row index in the Table $rowIndex has been deleted");
    return rowIndex;
  }

  static Future updateDatabaseRow(
      {required String tableName,
      required Map<String, Object?> updatedData,
      required String where,
      required List<String> whereArgs}) async {
    int updatedRowIndex = await _db!.update(tableName, updatedData,
        where: "$where = ?", whereArgs: whereArgs);
    Logger().f("this Row is Updated $updatedRowIndex");
    return updatedRowIndex;
  }
}
