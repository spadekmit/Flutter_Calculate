import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:xiaoming/src/command/cmdMethod.dart';
import 'package:xiaoming/src/command/handleCommand.dart';
import 'dart:io';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:xiaoming/src/command/matrix.dart';
import 'package:xiaoming/src/data/settingData.dart';

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

  ///处理字符命令
Future<String> handleCommand(String command) async {
  String cmd = command.trim().replaceAll(new RegExp('\n'), '');
  String result;
  //矩阵赋值语法的正则表达式
  RegExp inputMatrix = new RegExp(r"[A-Za-z][A-Za-z0-9]*(\s*)=(\s*)\[(.+)\]");
  //矩阵与浮点数运算的正则表达式
  RegExp matrixArithmetic = new RegExp(
      r"(^([A-Za-z][A-Za-z0-9]*)=)?([A-Za-z0-9\.\(\)]+)([\+|-|\*|/|\^]([A-Za-z0-9\.\(\)]+))*");
  RegExp definFunction = new RegExp(r"^(Fun)\s+[A-Za-z0-9]+\(.*\)\s*:(.*)");
  if (inputMatrix.firstMatch(cmd) != null) {
    result = _handleGetMatrix(cmd);
    //判断命令是否为矩阵和浮点数的运算
  } else if (definFunction.hasMatch(cmd)) {
    result = _handleDefinFunction(cmd);
  } else if (matrixArithmetic.firstMatch(cmd) != null) {
    result = await _handleMatrixArithmetic(cmd.replaceAll(' ', ''));
  } else {
    result = "$command  为未知命令";
  }
  return result;
}

/// 处理矩阵赋值的命令
String _handleGetMatrix(String cmd) {
  String name; //变量名
  int vertical; //行数， 列数
  List<List<num>> list = []; //存储数据的num数列
  //将变量名和矩阵数据分隔开
  List<String> strlist = cmd.split("=");
  name = strlist.first.trim();
  //去除矩阵数字两端的空格和方括号
  String listraw = strlist.last.trim().replaceAll('[', "").replaceAll(']', '');
  //用分号分割数据并记录行数
  List<String> lines = listraw.split(new RegExp(r'(\s*);(\s*)'));
  //记录第一行列数
  vertical = lines.first.split(new RegExp(r'(\s*,\s*)|,|\s+')).length;
  //往list中添加数据
  int index = 0;
  for (String line in lines) {
    list.add([]);
    List<String> numraws = line.split(new RegExp(r'(\s*,\s*)|,|\s+'));
    if (vertical == numraws.length) {
      //判断每一列个数是否相等
      for (String numraw in numraws) {
        num dnum = num.tryParse(numraw);
        if (dnum != null) {
          list[index].add(dnum);
        } else {
          return '非法字符： $numraw';
        }
      }
    } else {
      return '矩阵行数不一致';
    }
    index++;
  }
  if(UserData.matrixs.containsKey(name)){
    UserData.updateMatrix(name, list);
  }else if(UserData.dbs.containsKey(name)){
    UserData.dbs.remove(name);
    UserData.deleteNum(name);
  }else{
    UserData.addMatrix(name, list);
  }
  UserData.matrixs[name] = list;
  return MatrixUtil.mtoString(name: name, list: list);
}

/// 处理矩阵与浮点数的四则运算
Future<String> _handleMatrixArithmetic(String cmd) async{
  //存储结果的字符串
  String result;
  String newcmd;
  String name;
  //判断是否赋值
  if (cmd.contains('=')) {
    List<String> list = _splitEqual(cmd);
    name = list[0];
    newcmd = list[1];
  } else {
    newcmd = cmd;
  }
  //处理运算语句，返回运算结果或异常信息
  try {
    var re = await handleCalcuStr(newcmd);
    if (name != null) {
      if (re is List<List<num>>) {
        if(UserData.matrixs.containsKey(name)){
          UserData.updateMatrix(name, re);
        }else if(UserData.dbs.containsKey(name)){
          UserData.dbs.remove(name);
          UserData.deleteNum(name);
        }else{
          UserData.addMatrix(name, re);
        }
        UserData.matrixs[name] = MatrixUtil.copyMatrix(re); //将运算得到的矩阵添加到矩阵池
        result = MatrixUtil.mtoString(name: name, list: UserData.matrixs[name]);
      } else if (re is num) {
        if(UserData.dbs.containsKey(name)){
          UserData.updateNum(name, re);
        }else if(UserData.matrixs.containsKey(name)){
          UserData.matrixs.remove(name);
          UserData.deleteMatrix(name);
        }else{
          UserData.addNum(name, re);
        }
        UserData.dbs[name] = re; //将运算得到的浮点数添加到浮点池
        result = '$name = ' + re.toStringAsFixed(SettingData.fixedNum.round());
      } else {
        result = '该类型不能存储  $re';
      }
    } else {
      if (re is List<List<num>>) {
        result = MatrixUtil.mtoString(list: re);
      } else if (re is num) {
        result = re.toStringAsFixed(SettingData.fixedNum.round());
      } else {
        result = re.toString();
      }
    }
  } on FormatException catch (e) {
    result = e.message;
  }
  return result;
}

/// 处理函数调用字符串,返回函数调用结果
Future<dynamic> _invocationMethod(String cmd) async{
  int index = cmd.indexOf('(');
  String methodName = cmd.substring(0, index); //存储函数名
  String methodValue = cmd.substring(index + 1, cmd.length - 1); //存储函数参数
  //处理用户自定义函数调用
  if (isUserFun(methodName)) {
    UserFunction u = getUfByName(methodName);
    if (u != null) {
      return u.invoke(methodValue);
    }
  }

  //函数参数列
  List<dynamic> vals = await getMethodValue(methodValue);
  //根据函数名调用函数
  switch (methodName) {
    case 'inv':
      if (vals.length != 1 || vals[0] is! List<List<num>>)
        throw FormatException('inv函数参数传递错误');
      return MatrixUtil.getAdjoint(vals[0]);
    case 'tran':
      if (vals.length != 1 || vals[0] is! List<List<num>>)
        throw FormatException('tran函数参数传递错误');
      return MatrixUtil.transList(vals[0]);
    case 'value':
      if (vals.length != 1 || vals[0] is! List<List<num>>)
        throw FormatException('value函数参数传递错误');
      return MatrixUtil.getDetValue(vals[0]);
    case 'lagrange':
      if (vals.length != 3 ||
          !(vals[0] is List<List<num>>) ||
          !(vals[1] is List<List<num>>) ||
          !(vals[2] is List<List<num>>))
        throw FormatException('lagrange函数参数传递错误');
      return CmdMethodUtil.lagrange(vals[0], vals[1], vals[2]);
    case 'sum':
      if (vals.length != 1 || vals[0] is! List<List<num>>)
        throw FormatException('sum函数参数传递错误');
      return CmdMethodUtil.sum(vals[0]);
    case 'absSum':
      if (vals.length != 1 || vals[0] is! List<List<num>>)
        throw FormatException('absSum函数参数传递错误');
      return CmdMethodUtil.absSum(vals[0]);
    case 'average':
      if (vals.length != 1 || vals[0] is! List<List<num>>)
        throw FormatException('average函数参数传递错误');
      return CmdMethodUtil.average(vals[0]);
    case 'absAverage':
      if (vals.length != 1 || vals[0] is! List<List<num>>)
        throw FormatException('absAverage函数参数传递错误');
      return CmdMethodUtil.absAverage(vals[0]);
    case 'factorial':
      if (vals.length != 1 || vals[0] is! num)
        throw FormatException('factorial函数参数传递错误');
      return CmdMethodUtil.factorial(vals[0]);

    case 'sin':
      if (vals.length != 1 || vals[0] is! num)
        throw FormatException('sin函数参数传递错误');
      return sin(CmdMethodUtil.degToRad(vals[0]));

    case 'cos':
      if (vals.length != 1 || vals[0] is! num)
        throw FormatException('cos函数参数传递错误');
      return cos(CmdMethodUtil.degToRad(vals[0]));

    case 'tan':
      if (vals.length != 1 || vals[0] is! num)
        throw FormatException('tan函数参数传递错误');
      if (vals[0] == 90) {
        throw FormatException('tan(90)为无穷大');
      }
      return tan(CmdMethodUtil.degToRad(vals[0]));

    case 'asin':
      if (vals.length != 1 || vals[0] is! num)
        throw FormatException('asin函数参数传递错误');
      return CmdMethodUtil.radToDeg(asin(vals[0]));

    case 'acos':
      if (vals.length != 1 || vals[0] is! num)
        throw FormatException('acos函数参数传递错误');
      return CmdMethodUtil.radToDeg(acos(vals[0]));

    case 'atan':
      if (vals.length != 1 || vals[0] is! num)
        throw FormatException('atan函数参数传递错误');
      return CmdMethodUtil.radToDeg(atan(vals[0]));

    case 'radToDeg':
      if (vals.length != 1 || vals[0] is! num)
        throw FormatException('radToDeg函数参数传递错误');
      return CmdMethodUtil.radToDeg(vals[0]);
    case 'formatDeg':
      if (vals.length != 1 || vals[0] is! num)
        throw FormatException('formatDeg函数参数传递错误');
      return CmdMethodUtil.formatDeg(vals[0]);
    case 'reForDeg':
      if (vals.length != 1 || vals[0] is! num)
        throw FormatException('reForDeg函数参数传递错误');
      return CmdMethodUtil.reForDeg(vals[0]);
    case 'cofa':
      if (vals.length != 3 ||
          vals[0] is! List<List<num>> ||
          vals[1] is! num ||
          vals[2] is! num) {
        throw FormatException('cofa函数参数传递错误');
      }
      return MatrixUtil.getConfactor(vals[0], vals[1], vals[2]);
    case 'upmat':
      if (vals.length != 1 || vals[0] is! List<List<num>>) {
        throw FormatException('upmat函数参数传递错误');
      }
      return MatrixUtil.upperTriangular(vals[0]);
    case 'calculus':
      if(vals.length != 3){
        throw FormatException('积分函数参数数量错误');
      }
      if(vals[0] is! UserFunction || vals[1] is! num || vals[2] is! num){
        throw FormatException('积分函数参数类型传递错误');
      }
      return await CmdMethodUtil.handleCalculate(vals[0], vals[1], vals[2]);
    case 'roots':
      if(vals.length != 1 || vals[0] is! List<List<num>>){
        throw FormatException('多项式求根函数参数传递错误');
      }
      return CmdMethodUtil.polyomial(vals[0]);
    default:
      throw FormatException('$methodName 为未知命令');
  }
}

/// 处理定义函数字符串，保存定义函数
/// Fun juli(a,b,c,d) : a * b - c * d
String _handleDefinFunction(String cmd) {
  cmd = cmd.replaceAll(' ', '');
  var index1 = cmd.indexOf('(');
  var index2 = cmd.indexOf(':');
  var funName = cmd.substring(3, index1);
  var paras = cmd.substring(index1 + 1, index2 - 1);
  var funBody = cmd.substring(index2 + 1);
  var funCmds = funBody.split(';');
  List<String> cmds = [];
  List<String> funPara = [];
  for (String funcmd in funCmds) {
    if (funcmd.length > 0) {
      cmds.add(funcmd);
    }
  }
  for (String para in paras.split(',')) {
    funPara.add(para);
  }
  if(isUserFun(funName)){
    UserData.userFunctions.remove(getUfByName(funName));
  }
  UserData.userFunctions.add(new UserFunction(funName, funPara, cmds));
  UserData.addUF(funName, funPara, cmds);
  return '已保存';
}

///通过函数名返回用户自定义函数
UserFunction getUfByName(String funName) {
  for (UserFunction u in UserData.userFunctions) {
    if (u.funName == funName) {
      return u;
    }
  }
  return null;
}

///判断传入的函数名是否为用户已定义函数
bool isUserFun(String funName) {
  for (UserFunction u in UserData.userFunctions) {
    if (u.funName == funName) {
      return true;
    }
  }
  return false;
}

///获取函数参数列
Future<List<dynamic>> getMethodValue(String methodValue) async {
  List<String> values = methodValue.split(',');
  //将参数字符串转化为实际类型
  List<dynamic> vals = [];
  for (String str in values) {
    if(isUserFun(str)){
      vals.add(getUfByName(str));
    }else{
      vals.add(await handleCalcuStr(str));
    }
  }
  return vals;
}

/// 传入需要运算的语句，返回结果
Future<dynamic> handleCalcuStr(String caculStr) async{
  var temp = new Map();
  if (UserData.matrixs.containsKey(caculStr)) {
    return UserData.matrixs[caculStr];
  }
  if (UserData.dbs.containsKey(caculStr)) {
    return UserData.dbs[caculStr];
  }
  if (num.tryParse(caculStr) != null) {
    return num.tryParse(caculStr);
  }
  if (UserData.ufTemp.containsKey(caculStr)) {
    return UserData.ufTemp[caculStr];
  }
  caculStr = formatCmdStr(caculStr);
  if (caculStr.contains('(')) {
    var caculStrs = [];
    int index = -1;
    List<String> stack = [];
    for (int i = 0; i < caculStr.length; i++) {
      if (caculStr[i] == '(') {
        if (stack.length == 0) {
          caculStrs.add(new StringBuffer());
          index++;
        }
        stack.add('(');
        if (stack.length == 1) {
          continue;
        }
      }
      if (caculStr[i] == ')') {
        stack.removeLast();
        if (stack.length == 0) continue;
      }
      if (stack.length != 0) {
        caculStrs[index].write(caculStr[i]);
      }
    }

    if (caculStrs.length != 0) {
      for (int i = 0; i < caculStrs.length; i++) {
        RegExp inlayMethod = new RegExp(r'[A-Za-z]+\(' +
            caculStrs[i]
                .toString()
                .replaceAll('+', '\\+')
                .replaceAll('*', '\\*')
                .replaceAll('(', '\\(')
                .replaceAll(')', '\\)') +
            r'\)');
        if (inlayMethod.hasMatch(caculStr)) {
          temp['caculStrTemp$i'] =
              await _invocationMethod(inlayMethod.firstMatch(caculStr).group(0));
          caculStr = caculStr.replaceFirst(
              inlayMethod.firstMatch(caculStr).group(0), 'caculStrTemp$i');
          continue;
        }
        caculStr = caculStr.replaceFirst(
            '(' + caculStrs[i].toString() + ')', 'caculStrTemp$i');
        temp['caculStrTemp$i'] = await handleCalcuStr(caculStrs[i].toString());
      }
    }
  }
  RegExp oper = new RegExp(r'(\+|-|\*|/|\^)');
  List<String> varibales = caculStr.split(oper);
  //存储运算符的列表
  Iterable<Match> opers = oper.allMatches(caculStr);
  List<String> operStrs = [];
  //运算符列表
  for (Match m in opers) {
    operStrs.add(m.group(0));
  }
  //运算数列表
  List nums = [];
  for (String str in varibales) {
    if (num.tryParse(str) == null) {
      if (!UserData.ufTemp.containsKey(str)) {
        if (!UserData.matrixs.containsKey(str)) {
          if (!UserData.dbs.containsKey(str)) {
            if (!temp.containsKey(str)) {
              throw FormatException('未知的符号：  $str');
            } else {
              nums.add(temp[str]);
            }
          } else {
            nums.add(UserData.dbs[str]);
          }
        } else {
          nums.add(UserData.matrixs[str]);
        }
      } else {
        nums.add(UserData.ufTemp[str]);
      }
    } else {
      nums.add(num.tryParse(str));
    }
  }
  //根据运算符优先级调用运算符运算，直到运算符列表中没有值时返回运算值列表中的第一个数
  while (operStrs.length != 0) {
    String oper = _handleOperStrs(operStrs);
    int index = operStrs.indexOf(oper);
    operStrs.removeAt(index);
    var num1 = nums.removeAt(index);
    var num2 = nums.removeAt(index);
    nums.insert(index, _handleCacul(num1, num2, oper));
  }
  return nums[0];
}

///处理运算字符串中的负数（加上括号）
String formatCmdStr(String rawStr){
  ///先处理数字与字母或左括弧紧邻
  RegExp reg = new RegExp(r'[^A-Za-z][0-9\.]+[A-Za-z\(]+');
  while(reg.hasMatch(rawStr)){
    String str = reg.firstMatch(rawStr).group(0);
    int index = str.indexOf(new RegExp(r'[A-Za-z\(]'));
    String numStr = str.substring(1, index);
    String operStr = str.substring(0,1);
    String varStr = str.substring(index);
    rawStr = rawStr.replaceFirst(reg, operStr + numStr + '*' + varStr);
  }
  ///处理头部
  RegExp regF = new RegExp(r'^([0-9]+)[A-Za-z\(]+');
  if(regF.hasMatch(rawStr)){
    String str = regF.firstMatch(rawStr).group(0);
    int index = str.indexOf(new RegExp(r'[A-Za-z\(]'));
    String numStr = str.substring(0, index);
    String varStr = str.substring(index);
    rawStr = rawStr.replaceFirst(regF, numStr + '*' + varStr);
  }

  //处理尾部负数
  final negativeEnd = new RegExp(r'([\+\*-/]-[0-9\.]+)$');
  if(negativeEnd.hasMatch(rawStr)){
    final str = negativeEnd.firstMatch(rawStr).group(0);
    rawStr = rawStr.replaceFirst(negativeEnd, str.substring(0,1) +  '(' + str.substring(1) + ')');
  }
  //处理头部负数
  final negativeF = new RegExp(r'^(-[0-9\.]+[\+\*/-])');
  if(negativeF.hasMatch(rawStr)){
    final str1 = negativeF.firstMatch(rawStr).group(0);
    final str2 = str1.substring(str1.length - 1);
    rawStr = rawStr.replaceFirst(negativeF, '(' + str1.substring(0,str1.length - 1) + ')' + str2);
  }
  //处理中间负数
  final negativeM1 = new RegExp(r'[-/\+\*\^]-[0-9\.]+');
  while(negativeM1.hasMatch(rawStr)){
    final str = negativeM1.firstMatch(rawStr).group(0);
    final operStr = str.substring(0,1);
    rawStr = rawStr.replaceFirst(negativeM1, operStr + '(' + str.substring(1) +')');
  }
  final negativeM2 = new RegExp(r'\(-[0-9\.]+(\+|\*|-|/|\^)');
  while(negativeM2.hasMatch(rawStr)){
    final str = negativeM2.firstMatch(rawStr).group(0);
    final str1 = str.substring(str.length - 1);
    rawStr = rawStr.replaceFirst(negativeM2, '(' + '(' + str.substring(1,str.length - 1) + ')' + str1);
  }

  return rawStr;
}

/// 分离变量名和计算语句
List<String> _splitEqual(String cmd) {
  List<String> list = cmd.split('=');
  return list;
}

/// 处理运算符优先级
String _handleOperStrs(List<String> operStrs) {
  //先乘除再加减
  for (String oper in operStrs) {
    if (oper == '^') return oper;
  }
  for (String oper in operStrs) {
    if (oper == '*' || oper == '/') return oper;
  }
  return operStrs[0];
}

/// 处理两个值计算
dynamic _handleCacul(dynamic num1, dynamic num2, String oper) {
  if (num1 is num) {
    if (num2 is num) {
      //两个浮点数运算
      switch (oper) {
        case '*':
          return num1 * num2;
        case '/':
          return num1 / num2;
        case '+':
          return num1 + num2;
        case '-':
          return num1 - num2;
        case '^':
          return pow(num1, num2);
      }
    } else {
      //浮点数和矩阵运算
      switch (oper) {
        case '*':
          return MatrixUtil.m2dRide(num2, num1);
        case '/':
          return MatrixUtil.m2dDivide(num2, num1);
        case '+':
          return MatrixUtil.m2dPlus(num2, num1);
        case '-':
          return MatrixUtil.m2dMinus(num2, num1);
        case '^':
          throw FormatException('$num2 为矩阵不能进行指数运算');
      }
    }
  } else {
    if (num2 is num) {
      //浮点数和矩阵运算
      switch (oper) {
        case '*':
          return MatrixUtil.m2dRide(num1, num2);
        case '/':
          return MatrixUtil.m2dDivide(num1, num2);
        case '+':
          return MatrixUtil.m2dPlus(num1, num2);
        case '-':
          return MatrixUtil.m2dMinus(num1, num2);
        case '^':
          throw FormatException('$num2 为矩阵不能进行指数运算');
      }
    } else {
      //两个矩阵运算 ps:矩阵已重载运算符
      switch (oper) {
        case '*':
          return MatrixUtil.m2mRide(num1, num2);
        case '/':
          return MatrixUtil.m2mDivide(num1, num2);
        case '+':
          return MatrixUtil.m2mPlus(num1, num2);
        case '-':
          return MatrixUtil.m2mMinus(num1, num2);
        case '^':
          throw FormatException('$num2 为矩阵不能进行指数运算');
      }
    }
  }
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



