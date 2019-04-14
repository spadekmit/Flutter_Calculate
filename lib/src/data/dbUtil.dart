import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xiaoming/src/data/appData.dart';

class DBUtil {
  ///从字符串中读取矩阵（矩阵自动写入的格式）
  static List<List<num>> _stringToList(String str) {
    str = str.replaceAll(' ', '');
    List<String> list = str.split('],[');
    List<List<num>> result = [];
    var index = 0;
    for (String s in list) {
      result.add([]);
      List<String> temp = s.replaceAll('[', '').replaceAll(']', '').split(',');
      for (String s1 in temp) {
        result[index].add(num.parse(s1));
      }
      index++;
    }
    return result;
  }

  ///从数据库中读取存储的矩阵
  static Map<String, List<List<num>>> readMatrix() {
    var matrixs = new Map<String, List<List<num>>>();
    getDB().then((db) {
      db.rawQuery('select * from Matrixs').then((list) {
        list.forEach((m) {
          matrixs[m['name']] = _stringToList(m['value']);
        });
      });
    });
    return matrixs;
  }

  ///读取存储的用户自定义函数
  static List<UserFunction> readUserFun() {
    var userFunctions = new List<UserFunction>();
    getDB().then((db) {
      db.rawQuery('select * from UserFunction').then((list) {
        list.forEach((m) {
          String funName = m['funName'];
          List<String> paras = m['paras']
              .substring(1, m['paras'].length - 1)
              .replaceAll(' ', '')
              .split(',');
          List<String> funCmds =
              m['funCmds'].substring(1, m['funCmds'].length - 1).split(',');
          UserFunction uf = new UserFunction(funName, paras, funCmds);
          userFunctions.add(uf);
        });
      });
    });
    return userFunctions;
  }

  ///获取当前平台的数据库路径
  static Future<Database> getDB() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'xiaoming.db');
    if (!File(path).existsSync()) {
      return openDatabase(path, version: 1, onCreate: (db, version) async {
        await db
            .execute('create table Nums(name TEXT primary key, value DOUBLE);');
        await db.execute(
            'create table Matrixs(name TEXT primary key, value TEXT);');
        await db.execute('''
            create table UserFunction(funName TEXT primary key,
            paras TEXT, funCmds TEXT);
            ''');
        await db.execute(
            'create table Message(id integer primary key autoincrement, msg TEXT);');
      });
    } else {
      return openDatabase(path, version: 1);
    }
  }

    
  static Future<void> addMessage(String msg) async {
    Database db = await DBUtil.getDB();
    db.rawInsert('insert into Message(msg) values("$msg")');
  }
  
  static Future<void> deleteAllMessage() async {
    Database db = await DBUtil.getDB();
    db.rawDelete('delete from Message');
  }

  ///添加Num到数据库
  static void addNum(String name, num value) async {
    Database db = await getDB();
    db.rawInsert('INSERT INTO Nums(name, value) VALUES("$name", $value)');
  }

  ///从数据库中读取num
  static Map<String, num> readNum() {
    var dbs = new Map<String, num>();
    getDB().then((db) {
      db.rawQuery('SELECT * FROM Nums').then((list) {
        list.forEach((m) {
          dbs[m['name']] = num.parse(m['value'].toString());
        });
      });
    });
    return dbs;
  }

  ///删除数据库中所有Num
  static Future<void> deleteAllNum() async {
    Database db = await getDB();
    db.rawDelete('DELETE FROM Nums');
  }

  ///更新数据库中某个num的值
  static Future<void> updateNum(String name, num value) async {
    Database db = await getDB();
    db.rawUpdate('UPDATE Nums SET value = $value WHERE name = "$name"');
  }

  static Future<void> deleteNum(String name) async {
    Database db = await getDB();
    db.rawDelete('delete from Nums where name = "$name"');
  }

  ///添加Matrix到数据库
  static Future<void> addMatrix(String name, List<List<num>> matrix) async {
    Database db = await getDB();
    db.rawInsert(
        'insert into Matrixs(name, value) values("$name", "${matrix.toString()}")');
  }

  ///更新数据库中对应name的值
  static Future<void> updateMatrix(String name, List<List<num>> matrix) async {
    Database db = await getDB();
    db.rawUpdate(
        'update Matrixs set value = "${matrix.toString()}" where name = "$name"');
  }

  static Future<void> deleteMatrix(String name) async {
    Database db = await getDB();
    db.rawDelete('delete from Matrixs where name = "$name"');
  }

  ///删除数据库中所有Matrix
  static Future<void> deleteAllMatrix() async {
    Database db = await getDB();
    db.rawDelete('delete from Matrixs');
  }

  static Future<void> addUF(
      String funName, List<String> paras, List<String> funCmds) async {
    Database db = await getDB();
    db.rawInsert(
        'insert into UserFunction(funName, paras, funCmds) values("$funName", "${paras.toString()}", "${funCmds.toString()}")');
  }

  static Future<void> deleteUF(String funName) async {
    Database db = await getDB();
    db.rawDelete('delete from UserFunction where funName = "$funName"');
  }

  static Future<void> deleteAllUF() async {
    Database db = await getDB();
    db.rawDelete('delete from UserFunction');
  }
}
