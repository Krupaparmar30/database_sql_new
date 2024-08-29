



import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static DbHelper dbHelper = DbHelper._();

  DbHelper._();

  Database? _db;

  Future get database async => _db ?? await initDatabase();


  //init database-create table

  Future initDatabase() async {
    //1.create path to store data
    //
    // base
    final path = await getDatabasesPath();
    final dbpath = join(path, 'finance.db');

    _db = await openDatabase(
      dbpath,
      version: 1,
      onCreate: (db, version) async {
        String sql = '''
     CREATE TABLE finance(
     id INTEGER PRIMARY KEY AUTOINCREMENT ,
     amount REAL NOT NULL,
     isIncome INTEGER NOT NULL,
     category TEXT,
     img TEXT
     );
    ''';
        await db.execute(sql);
      },
    );
    return _db;
  }

  Future insertData(double amount,int isIncome,String category,String img) async {
    Database? db =await database;

    String sql='''
    INSERT INTO finance
    (amount,isIncome,category,img) VALUES (?,?,?,?);
    
    ''';
    List args=[amount,isIncome,category,img];
    await db!.rawInsert(sql,args);
  }

  Future<List<Map>> readData()
  async {
    Database? db=await  database;
    String sql='''
    
    SELECT * FROM finance
    
    ''';
    return await db!.rawQuery(sql);
  }
  Future<List<Map>> readLiveData(String category)
  async {
    Database? db=await  database;
    String sql='''
    
    SELECT * FROM finance WHERE category LIKE '%$category%'
    
    ''';
    return await db!.rawQuery(sql);
  }
  Future deleteData(int id)
  async {
    Database? db=await database;

    String sql='''
    DELETE FROM finance WHERE id=?
    
    ''';
    List args=[id];
    await db!.rawDelete(sql,args);

  }



  Future updateData(int id,double amount ,int isIncome,String category,String img)
  async {
    Database? db=await database;
    String sql='''
    
    UPDATE finance SET amount=? ,isIncome=?,category=? ,img=? WHERE id=?
    ''';
    List args=[amount,isIncome,category,img,id];
    await db!.rawUpdate(sql,args);
  }

}
