import 'dart:math';

class NonlinearEquationUtil {
  _NonlinearEquationUtil() {}

  static final NonlinearEquationUtil instance = new NonlinearEquationUtil();

  static getInstance() {
    return instance;
  }
  //-3x^3+5x-10
  String handleNonlinearEquation(String command, String x){
    var reg = new RegExp(r'[0-9]+' + x);
    while(reg.hasMatch(command)){
      String temp = reg.firstMatch(command).group(0);
      int index = temp.indexOf(x);
      command = command.replaceFirst(reg, temp.substring(0, index) + '*' + x);
    }
    return command;
  }

  dynamic handleCalcuStr(String caculStr) {
    var temp = new Map();
    if (num.tryParse(caculStr) != null) {
      return num.tryParse(caculStr);
    }
    var negative = new RegExp(r'(([^A-Za-z0-9]-)|(^-))[A-Za-z0-9]+[^\)]');
    var minus = new RegExp(r'(([^A-Za-z0-9]-)|(^-))[A-Za-z0-9]+');
    while (negative.hasMatch(caculStr)) {
      String str1 = negative.firstMatch(caculStr).group(0);
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
        if (!temp.containsKey(str)) {
          throw FormatException('未知的符号：  $str');
        } else {
          nums.add(temp[str]);
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
        throw FormatException('未知的符号： $num2');
      }
    } else {
      throw FormatException('未知的符号： $num1');
    }
  }
}
