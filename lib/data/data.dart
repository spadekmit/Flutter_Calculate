import 'package:xiaoming/command/handleCommand.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

Map<String, num> dbs = new Map(); //存储浮点数变量

Map<String, List<List<num>>> matrixs = new Map(); //存储矩阵变量
double fixedNum = 6.0; //存储小数位值
bool isHorizontalBottons = false;
List<UserFunction> userFunctions = [];
var UFtemp = new Map();

List<CmdMethod> cmdMethods = [
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
      '求代数余子式',
      'Matrix complementary',
      'cofa',
      'Usage: cofa(A,x,y), A is the original matrix of the cofactor,x and y are the row and column Numbers of the cofactor.Note: x and y must be less than the number of rows and columns in A.',
      '用法：cofa(A,x,y)，A为所求余子式的原矩阵，x和y为所求代数余子式的行号和列号。注意：x和y必须小于A的行数和列数。'),
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

class CmdMethod {
  String name; //函数名
  String Ename;
  String cmdText; //函数命令
  String EmethodDescription; //函数操作文本
  String methodDescription; //函数详细描述

  CmdMethod(this.name, this.Ename, this.cmdText, this.EmethodDescription,
      this.methodDescription);
}

class UserFunction {
  String funName;
  List<String> paras;
  List<String> funCmds;
  UserFunction(this.funName, this.paras, this.funCmds);

  ///自定义函数执行。
  dynamic invoke(String methodVals) {
    var result;
    List<dynamic> vals = getMethodValue(methodVals);
    if (vals.length != this.paras.length) {
      throw FormatException('$funName 方法的参数数量传递错误');
    }
    for (int i = 0; i < paras.length; i++) {
      UFtemp[paras[i]] = vals[i];
    }
    for (int j = 0; j < funCmds.length; j++) {
      result = handleCommand(funCmds[j]);
    }
    for (var s in paras) {
      UFtemp.remove(s);
    }
    return result;
  }
}

///将设置界面的数据存储到文件
Future writeSettingData() async {
  String dir = (await getApplicationDocumentsDirectory()).path;
  File settingDataFile = new File('$dir/settingdata.txt');
  if (settingDataFile.existsSync()) {
    settingDataFile.delete();
  }
  settingDataFile.createSync();
  settingDataFile.writeAsStringSync(
      fixedNum.toString() + '|' + isHorizontalBottons.toString());
}

///从文件读取到设置界面的数据
Future readSettingData() async {
  String dir = (await getApplicationDocumentsDirectory()).path;
  File settingDataFile = new File('$dir/settingdata.txt');
  if (settingDataFile.existsSync()) {
    String data = settingDataFile.readAsStringSync();
    var vals = data.split('|');
    fixedNum = double.parse(vals[0]);
    if (vals[1].trim() == 'true') {
      isHorizontalBottons = true;
    } else {
      isHorizontalBottons = false;
    }
  } else {
    fixedNum = 6.0;
  }
}

void loadData() async {
  readDbs();
  readMatrixs();
  readUserFun();
}

///获取存储矩阵的文件
Future<File> _getMatrixsFile() async {
  // get the path to the document directory.
  String dir = (await getApplicationDocumentsDirectory()).path;
  return new File('$dir/matrixs.txt');
}

///获取存储数字的文件
Future<File> _getDbsFile() async {
  // get the path to the document directory.
  String dir = (await getApplicationDocumentsDirectory()).path;
  return new File('$dir/dbs.txt');
}

///获取存储用户自定义函数的文件
Future<File> _getUserFunFile() async {
  String dir = (await getApplicationDocumentsDirectory()).path;
  return new File('$dir/userFun.txt');
}

///读取存储的矩阵
Future readMatrixs() async {
  File matrixFile = await _getMatrixsFile();
  if (matrixFile.existsSync()) {
    String matrixsStr = matrixFile.readAsStringSync();
    List<String> matrixStr = matrixsStr.split(';');
    for (String str in matrixStr) {
      if (str.contains(':')) {
        List<String> strs = str.split(':');
        String name = strs[0];
        List<List<num>> value = stringToList(strs[1]);
        matrixs[name] = value;
      }
    }
  }
}

///读取存储的数字
Future readDbs() async {
  File dbsFile = await _getDbsFile();
  if (dbsFile.existsSync()) {
    String matrixsStr = dbsFile.readAsStringSync();
    List<String> dbstr = matrixsStr.split(';');
    for (String str in dbstr) {
      if (str.contains(':')) {
        List<String> strs = str.split(':');
        String name = strs[0];
        num value = num.parse(strs[1]);
        dbs[name] = value;
      }
    }
  }
}

///读取存储的用户自定义函数
Future readUserFun() async {
  File UserFunFile = await _getUserFunFile();
  if (UserFunFile.existsSync()) {
    String userFunStr = UserFunFile.readAsStringSync();
    List<String> ufstr = userFunStr.split('/');
    for (String str in ufstr) {
      if (str.length == 0) continue;
      List<String> strs = str.split('|');
      String funName = strs[0];
      List<String> paras = strs[1].substring(1, strs[1].length - 1).split(',');
      List<String> funCmds =
          strs[2].substring(1, strs[2].length - 1).split(',');
      UserFunction uf = new UserFunction(funName, paras, funCmds);
      userFunctions.add(uf);
    }
  }
}

Future writeUserFun() async {
  File userFunFile = await _getUserFunFile();
  if (userFunFile.existsSync()) {
    userFunFile.delete();
  }
  userFunFile.createSync();
  var sb = new StringBuffer();
  userFunctions.forEach((UserFunction u) {
    sb.write(u.funName);
    sb.write('|');
    sb.write(u.paras);
    sb.write('|');
    sb.write(u.funCmds);
    sb.write('/');
  });
}

///从字符串中读取矩阵（矩阵自动写入的格式）
List<List<num>> stringToList(String str) {
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

///将内存中的矩阵列存储到文件
writeMatrix() async {
  File matrixsFile = await _getMatrixsFile();
  if (matrixsFile.existsSync()) {
    matrixsFile.delete();
  }
  await matrixsFile.create();
  var sb = new StringBuffer();
  matrixs.forEach((name, value) => sb.write('$name:$value;'));
  matrixsFile.writeAsStringSync(sb.toString());
}

///将内存中的数字列存储到文件
writeDb() async {
  File DbsFile = await _getDbsFile();
  if (DbsFile.existsSync()) {
    DbsFile.delete();
  }
  await DbsFile.create();
  var sb = new StringBuffer();
  dbs.forEach((name, value) => sb.write('$name:$value;'));
  DbsFile.writeAsStringSync(sb.toString());
}
