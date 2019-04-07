import 'package:flutter/cupertino.dart';
import 'package:xiaoming/src/command/handleCommand.dart';
import 'dart:io';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserData with ChangeNotifier{
  static String language = 'en';
  static bool isUnload = true;
  static int nowPage = 0;
  static BuildContext pageContext;
  static Map<String, num> dbs; //存储浮点数变量
  static Map<String, List<List<num>>> matrixs; //存储矩阵变量
  static List<UserFunction> userFunctions; //存储用户自定义函数
  static Map ufTemp = new Map(); //存储调用用户自定义函数时传入的参数
  static List<CmdMethod> cmdMethods = [
    new CmdMethod(
        '矩阵求逆',
        'matrix inversion',
        'inv',
        'Usage: inv(A), A must be a square matrix, and the value of the determinant is not zero',
        '用法：inv(A)， A必须为方阵，且行列式的值不为零'),
    new CmdMethod('矩阵转置', 'matrix transposition', 'tran',
        'Usage: tran(A), A must be a matrix', '用法：tran(A),  A必须为矩阵'),
    new CmdMethod('矩阵求值', 'evaluation of deteminant', 'value',
        'Usage: value(A), A must be a square matrix', '用法：value(A), A必须为方阵'),
    new CmdMethod(
        '上三角矩阵',
        'upper triangular matrix',
        'upmat',
        'Usage: upmat(A), A must be a Square matrix or augmented matrix',
        '用法：upmat(A), A必须为方阵或增广矩阵'),
    new CmdMethod(
        '求代数余子式',
        'Matrix complementary',
        'cofa',
        'Usage: cofa(A,x,y), A is the original matrix of the cofactor,x and y are the row and column Numbers of the cofactor.Note: x and y must be less than the number of rows and columns in A.',
        '用法：cofa(A,x,y)，A为所求余子式的原矩阵，x和y为所求代数余子式的行号和列号。注意：x和y必须小于A的行数和列数。'),
    new CmdMethod(
        '求多项式的所有根',
        'All roots of polynomials',
        'roots',
        'Usage: roots (c), c for prayer polynomial coefficient example: c1 c2 * * x ^ 3 + x ^ 2 + x + c4 c3 * = 0, the first input c = (c1, c2, c3, c4) using the roots (c) all roots of polynomial',
        '用法：roots(c)，c为所求多项式的系数 例：c1*x^3+c2*x^2+c3*x+c4=0 ,则先输入c = [c1,c2,c3,c4] 再使用roots(c)求多项式的所有根'),
    new CmdMethod(
        '求解微积分',
        'Differential and integral calculus',
        'calculus',
        "Usage: calculus(f,a,b,c), F is for the integrand (first create the function with Fun 'funname' and then take the function name as the first argument, the function f must be a single argument and return a function of real Numbers.A and b are integral intervals, such as 1 and 2.C is the number of cycles (the larger c is, the more accurate the result is, and the slower the solution speed is), which can be omitted, and the default is 1000.",
        "用法：calculus(f,a,b,c)，f为被积函数（先用 Fun 'funname'创建函数，再将函数名作为第一个参数,函数f必须为单参数且返回实数的函数。a和b为积分区间，例如 1，2。c为循环次数（c越大结果越准确，求解速度越慢）可以省略，默认为1000。"),
    new CmdMethod(
        '拉格朗日插值法',
        'Lagrange\'s interpolation',
        'lagrange',
        'Usage: lagrange(A,B,C), A is the x-value column of the node, B is the y-value column of the node, and C is the x-value column of the desired point',
        '用法：lagrange(A,B,C), A为节点的x值列，B为节点的y值列，C为所求点的x值列'),
    new CmdMethod(
        '求和',
        'sum',
        'sum',
        'Usage: sum(A), A must be a matrix, find the sum of all the values in the matrix',
        '用法：sum(A), A必须为矩阵，求矩阵内所有值的和'),
    new CmdMethod(
        '求绝对值之和',
        'absolute sum',
        'absSum',
        'Usage: absSum(A), A must be a matrix, find the sum of the absolute values of all the values in the matrix',
        '用法：absSum(A), A必须为矩阵，求矩阵内所有值的绝对值之和'),
    new CmdMethod(
        '平均值',
        'average',
        'average',
        'Usage: average(A), A must be a matrix, find the average of all values in the matrix',
        '用法：average(A), A必须为矩阵，求矩阵内所有值的平均值'),
    new CmdMethod(
        '绝对值的平均值',
        'absolute average',
        'absAverage',
        'Usage: absAverage(A), A must be a matrix, find the average of the absolute values of all values in the matrix',
        '用法：absAverage(A), A必须为矩阵，求矩阵内所有值的绝对值的平均值'),
    new CmdMethod(
        '阶乘',
        'factorial',
        'factorial',
        'Usage: factorial(A), A must be a positive integer, find the factorial of the number (if the decimal is passed, it will be rounded to an integer)',
        '用法：factorial(A), A必须为正整数，求该数的阶乘(若传入小数会四舍五入转成整数'),
    new CmdMethod(
        'sin',
        'sin',
        'sin',
        'Usage: sin(A), A must be angle Example: 134.9824 or reForDeg(134.59(minutes)57(seconds)',
        "用法：sin(A), A必须为角度 例：'134.9824'或'reForDeg(134.59(分）57（秒）'"),
    new CmdMethod(
        'cos',
        'cos',
        'cos',
        'Usage: cos(A), A must be angle Example: 134.9824 or reForDeg(134.59(minutes)57(seconds)',
        "用法：cos(A), A必须为角度 例：'134.9824'或'reForDeg(134.59(分）57（秒）'"),
    new CmdMethod(
        'tan',
        'tan',
        'tan',
        'Usage: tan(A), A must be angle Example: 134.9824 or reForDeg(134.59(minutes)57(seconds)',
        "用法：tan(A), A必须为角度 例：'134.9824'或'reForDeg(134.59(分）57（秒）'"),
    new CmdMethod(
        'asin',
        'asin',
        'asin',
        'Usage: asin(A), A must be a number Example: 0.5, return angle, use formatDeg(asin(0.5)) if you want to display degrees and minutes.',
        "用法：asin(A), A必须为数字 例：'0.5 ，返回角度，若需显示度分秒则使用 formatDeg(asin(0.5))"),
    new CmdMethod(
        'acos',
        'acos',
        'acos',
        'Usage: acos(A), A must be a number Example: 0.5, return angle, use formatDeg(acos(0.5)) if you want to display degrees and minutes.',
        "用法：acos(A), A必须为数字 例：'0.5，返回角度，若需显示度分秒则使用 formatDeg(acos(0.5))"),
    new CmdMethod(
        'atan',
        'atan',
        'atan',
        'Usage: atan(A), A must be a number Example: 0.5, return angle, use formatDeg(atan(0.5)) if you want to display degrees and minutes.',
        "用法：atan(A), A必须为数字 例：'0.5，返回角度，若需显示度分秒则使用 formatDeg(atan(0.5))"),
    new CmdMethod(
        '格式化角度',
        'format degree',
        'formatDeg',
        'Usage: formatDeg(A), A must be a number Example: formatDeg(134.9824) = 134°59′57″',
        "用法：formatDeg(A), A必须为数字 例：'formatDeg(134.9824) = 134°59′57″ "),
    new CmdMethod(
        '反格式化角度',
        'unformat degree',
        'reForDeg',
        'Usage: reForDeg(A), A must be a number Example: reForDeg(134.5957) = 134.9824',
        "用法：reForDeg(A), A必须为数字 例：'reForDeg(134.5957) = 134.9824 "),
    new CmdMethod(
        '弧度转角度',
        'radians to degrees',
        'radToDeg',
        'Usage: radToDeg(A), A must be a number Example: reForDeg(1) = 57.29578',
        "用法：radToDeg(A), A必须为数字 例：'reForDeg(1) = 57.29578 "),
  ];

  ///加载用户自定义函数,浮点数和矩阵
  static Future loadData() async {
    if (dbs.isEmpty &&
        matrixs.isEmpty &&
        userFunctions.isEmpty) {
      readNum();
      readMatrix();
      readUserFun();
    }
  }

  ///从数据库中读取存储的矩阵
  static Future<void> readMatrix() async {
    Database db = await getDB();
    var list = await db.rawQuery('select * from Matrixs');
    list.forEach((m) {
      matrixs[m['name']] = _stringToList(m['value']);
    });
  }

  ///读取存储的用户自定义函数
  static Future<void> readUserFun() async {
    Database db = await getDB();
    var list = await db.rawQuery('select * from UserFunction');
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
  }

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

  ///添加Num到数据库
  static void addNum(String name, num value) async {
    Database db = await getDB();
    db.rawInsert('INSERT INTO Nums(name, value) VALUES("$name", $value)');
  }

  ///从数据库中读取num
  static void readNum() {
    getDB().then((db) {
      db.rawQuery('SELECT * FROM Nums').then((list) {
        list.forEach((m) {
          dbs[m['name']] = num.parse(m['value'].toString());
        });
      });
    });
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

///内置的命令行函数
class CmdMethod {
  String name; //函数名
  String ename; //函数的英文名
  String cmdText; //函数命令
  String emethodDescription; //函数的英文详细描述
  String methodDescription; //函数详细描述

  CmdMethod(this.name, this.ename, this.cmdText, this.emethodDescription,
      this.methodDescription);
}

///用户自定义函数
class UserFunction {
  String funName;
  List<String> paras;
  List<String> funCmds;
  UserFunction(this.funName, this.paras, this.funCmds);

  ///自定义函数执行。
  Future<String> invoke(String methodVals) async {
    String result;
    List<dynamic> vals = await getMethodValue(methodVals);
    if (vals.length != this.paras.length) {
      throw FormatException('$funName 方法的参数数量传递错误');
    }
    for (int i = 0; i < paras.length; i++) {
      UserData.ufTemp[paras[i]] = vals[i];
    }
    for (int j = 0; j < funCmds.length; j++) {
      result = await handleCommand(funCmds[j]);
    }
    for (var s in paras) {
      UserData.ufTemp.remove(s);
    }
    return result;
  }
}
