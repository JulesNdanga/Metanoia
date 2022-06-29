import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_admob/Model/bookmark.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {}

class bookmarkHelper {
  //table name
  String TABLE_NAME = "bookmarked";
  //column name
  String v_id = "v_id";

  bookmarkHelper.privateConstructor();

  static final bookmarkHelper instance = bookmarkHelper.privateConstructor();
  //static final DatabaseHelper instance2 = DatabaseHelper.privateConstructor();
  static Database bdb;

  Future<Database> get database async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "bookmark.db");
    var exists = await databaseExists(path);
    if (!exists) {
      // This will get initiate only on the first time you launch your application
      print("Creating new copy from asset >>>");
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "bookmark.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      //DB ALready exists return the db
      print("Opening existing database >>>");
    }

    // open the database
    bdb = await openDatabase(path);
    return bdb;
  }

  //insert chapter id in table to save as bookmarked
  insertIntoDb(int id1) async {
    final bdb = await database;
    var response =
        await bdb.rawInsert("INSERT INTO bookmarked (v_id)" "VALUES ($id1)");
    print("insert.....$response");
    return response;
  }

  //delete
  delete_id(int id1) async {
    final bdb = await database;
    var response =
        await bdb.delete(TABLE_NAME, where: '$v_id = ?', whereArgs: [id1]);
    print("delete.....$response");
    return response;
  }

  //get bookmark
  Future<List<Bookmark>> getBookmarks() async {
    final bdb = await database;
    //  var response = await bdb.rawQuery("SELECT * FROM " + TABLE_NAME+ " WHERE " + v_id+ " = ? ",[id]);
    var response = await bdb.rawQuery("SELECT * FROM $TABLE_NAME ");
    List<Bookmark> list = response.map((c) => Bookmark.fromJson(c)).toList();
    print("-------- **$response");
    return list;
  }
}
