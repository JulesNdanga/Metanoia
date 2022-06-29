import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_admob/Model/Category.dart';
import 'package:flutter_admob/Model/detail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  String Tbl_detail = "tbl_detail";
  String Category_Id = "Category_Id";
  String ID = "Id";

  DatabaseHelper.privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper.privateConstructor();
  static Database db;
  Future<Database> get database async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "lorem_lpsum.db");
    var exists = await databaseExists(path);
    if (!exists) {
      // This will get initiate only on the first time you launch your application
      print("Creating new copy from asset >>>");
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "lorem_lpsum.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      //DB ALready exists return the db
      print("Opening existing database >>>");
    }
    // open the database
    db = await openDatabase(path, readOnly: true);
    return db;
  }

//get main page
  Future<List<Category>> getCategory() async {
    final db = await database;
    //Using a RAW Query here to fetch the list of data
    var response = await db.rawQuery("SELECT * FROM tbl_category");
    List<Category> list = response.map((c) => Category.fromJson(c)).toList();
    debugPrint("list-----$list");
    return list;
  }

  //get chapters
  Future<List<detail>> getDetail(int id) async {
    final db = await database;
    //Using a RAW Query here to fetch the list of data
    var response = await db.rawQuery(
        "SELECT * FROM " + Tbl_detail + " WHERE " + Category_Id + " = ? ",
        [id]);
    List<detail> list = response.map((c) => detail.fromJson(c)).toList();
    print(list);
    return list;
  }

  //get Description
  Future<List<detail>> getDetail1(int id1) async {
    final db = await database;
    //Using a RAW Query here to fetch the list of data
    var response = await db.rawQuery(
        "SELECT * FROM " + Tbl_detail + " WHERE " + ID + " = ? ", [id1]);
    List<detail> list = response.map((c) => detail.fromJson(c)).toList();
    print(list);
    return list;
  }

  //get search
  Future<List<detail>> getSearch() async {
    final db = await database;
    //Using a RAW Query here to fetch the list of data
    var response = await db.rawQuery("SELECT * FROM " + Tbl_detail);
    List<detail> list = response.map((c) => detail.fromJson(c)).toList();
    print(list);
    return list;
  }
}
