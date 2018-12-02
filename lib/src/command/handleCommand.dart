import 'dart:math';

import 'package:xiaoming/src/command/matrix.dart';
import 'package:xiaoming/src/command/cmdMethod.dart';
import 'package:xiaoming/src/data/appData.dart';
import 'package:xiaoming/src/data/settingData.dart';

///处理字符命令
String handleCommand(String command) {
  String cmd = command.trim().replaceAll(new RegExp(r'\r|\t|\n'), '');
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
    result = _handleMatrixArithmetic(cmd.replaceAll(' ', ''));
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
  UserData.matrixs.remove(name);
  UserData.dbs.remove(name);
  UserData.matrixs[name] = list;
  UserData.writeMatrix();
  return MatrixUtil.mtoString(name: name, list: list);
}

/// 处理矩阵与浮点数的四则运算
String _handleMatrixArithmetic(String cmd) {
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
    var re = handleCalcuStr(newcmd);
    if (name != null) {
      if (re is List<List<num>>) {
        UserData.dbs.remove(name);
        UserData.matrixs[name] = MatrixUtil.copyMatrix(re); //将运算得到的矩阵添加到矩阵池
        UserData.writeMatrix();
        result = MatrixUtil.mtoString(name: name, list: UserData.matrixs[name]);
      } else if (re is num) {
        UserData.matrixs.remove(name);
        UserData.dbs[name] = re; //将运算得到的浮点数添加到浮点池
        UserData.writeDb();
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
dynamic _invocationMethod(String cmd) {
  int index = cmd.indexOf('(');
  String methodName = cmd.substring(0, index); //存储函数名
  String methodValue = cmd.substring(index + 1, cmd.length - 1); //存储函数参数
  //处理用户自定义函数调用
  if (UFcontain(methodName)) {
    UserFunction u = getUfByName(methodName);
    if (u != null) {
      return u.invoke(methodValue);
    }
  }

  //函数参数列
  List<dynamic> vals = getMethodValue(methodValue);
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
      if(vals.length != 3 && vals.length !=4){
        throw FormatException('积分函数参数数量错误');
      }
      if(vals[0] is! UserFunction || vals[1] is! num || vals[2] is! num){
        throw FormatException('积分函数参数类型传递错误');
      }
      if(vals.length == 4){
        if(vals[3] is! num){
          throw FormatException('积分函数参数类型传递错误');
        }
        return CmdMethodUtil.calculus(vals[0], vals[1], vals[2],loops: vals[3]);
      }
      return CmdMethodUtil.calculus(vals[0], vals[1], vals[2]);
    case 'roots':
      if(vals.length != 1 || vals[0] is! List<List<num>>){
        throw FormatException('多项式求根函数参数传递错误');
      }
      return CmdMethodUtil.Polyomial(vals[0]);
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
    if (funcmd.length > 1) {
      cmds.add(funcmd);
    }
  }
  for (String para in paras.split(',')) {
    funPara.add(para);
  }
  if(UFcontain(funName)){
    UserData.userFunctions.remove(getUfByName(funName));
  }
  UserData.userFunctions.add(new UserFunction(funName, funPara, cmds));
  UserData.writeUserFun();
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
bool UFcontain(String funName) {
  for (UserFunction u in UserData.userFunctions) {
    if (u.funName == funName) {
      return true;
    }
  }
  return false;
}

///获取函数参数列
List<dynamic> getMethodValue(String methodValue) {
  List<String> values = methodValue.split(',');
  //将参数字符串转化为实际类型
  List<dynamic> vals = [];
  for (String str in values) {
    if(UFcontain(str)){
      vals.add(getUfByName(str));
    }else{
      vals.add(handleCalcuStr(str));
    }
  }
  return vals;
}

/// 传入需要运算的语句，返回结果
dynamic handleCalcuStr(String caculStr) {
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
  if (UserData.UFtemp.containsKey(caculStr)) {
    return UserData.UFtemp[caculStr];
  }
  var negative = new RegExp(r'(([^A-Za-z0-9]-)|(^-))[A-Za-z0-9\.]+.');
  var minus = new RegExp(r'(([^A-Za-z0-9]-)|(^-))[A-Za-z0-9\.]+');
  while (negative.hasMatch(caculStr)) {
    String str1 = negative.firstMatch(caculStr).group(0);
    String temp = str1.substring(str1.length-1);
    if(temp == ')'){
      break;
    }
    var str2 = minus.firstMatch(str1).group(0);
    var str3 = str1.replaceAll(str2, '');
    int index = str1.indexOf('-');
    caculStr = caculStr.replaceFirst(
        negative,
        str1.substring(0, index) +
            '(' +
            str1.substring(index).replaceAll(str3, '') +
            ')' +
            str3);
  }
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
              _invocationMethod(inlayMethod.firstMatch(caculStr).group(0));
          caculStr = caculStr.replaceFirst(
              inlayMethod.firstMatch(caculStr).group(0), 'caculStrTemp$i');
          continue;
        }
        caculStr = caculStr.replaceFirst(
            '(' + caculStrs[i].toString() + ')', 'caculStrTemp$i');
        temp['caculStrTemp$i'] = handleCalcuStr(caculStrs[i].toString());
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
      if (!UserData.UFtemp.containsKey(str)) {
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
        nums.add(UserData.UFtemp[str]);
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
