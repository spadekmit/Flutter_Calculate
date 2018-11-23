import 'dart:math';

import 'package:xiaoming/src/command/matrix.dart';
import 'package:xiaoming/src/data/data.dart';

class EquationsUtil {
  _EquationsUtil() {}

  static final EquationsUtil instance = new EquationsUtil();
  static List<List<num>> postMatrix = [];
  static List<List<num>> constant = [];
  ///获取已缓存的实例
  static EquationsUtil getInstance() {
    return instance;
  }
  ///传入线性方程组和变量求得结果
  ///@param raweuations  线性方程组，以逗号隔开
  ///@param rawvars      所有变量，以逗号隔开
  String handleLineEquations(String raweuations, String rawvars) {
    RegExp char = new RegExp(r'^[A-Za-z]+[0-9]*');
    var varmap = new Map();
    String result = '';
    var index = 0;
    var equations = raweuations.split(',');
    var vars = rawvars.split(',');
    if (equations.length != vars.length) {
      return '方程个数应与未知数个数相等';
    }
    for (int i = 0; i < vars.length; i++) {
      postMatrix.add([]);
      constant.add([]);
      constant[i].add(0);
      for (int j = 0; j < vars.length; j++) {
        postMatrix[i].add(0);
      }
    }
    for (var v in vars) {
      if (!char.hasMatch(v)) {
        return '变量必须以字母开头，数字只能放在结尾位置';
      }
      varmap[v] = index;
      index++;
    }
    var equationIndex = 0;
    for (var equation in equations) {
      var reg = RegExp(r'=');
      var matchs = reg.allMatches(equation);
      if (matchs.length != 1) {
        return '方程中等号数量错误';
      }
      if (equation.contains(RegExp(r'\*|/'))) {
        return '线性方程组不处理乘除运算';
      }
      var lr = equation.split('=');
      var leftEquation = lr[0];
      var rightEquation = lr[1];
      try{
        simplifiedEquation(leftEquation, varmap, true, equationIndex);
        simplifiedEquation(rightEquation, varmap, false, equationIndex);
      }catch(e){
        return e.toString();
      }
      equationIndex++;
    }
    var resultList = m2mRide(getAdjoint(postMatrix), constant);
    var sb = new StringBuffer();
    for(int i=0;i<vars.length;i++){
      sb.write(vars[i] + ':   ' + resultList[i][0].toStringAsFixed(fixedNum.round()));
      sb.write('\n');
    }
    result = sb.toString();
    postMatrix = [];
    constant = [];
    return result;
  }
  ///传入方程字符串，将系数添加到系数阵，常数添加到常数阵
  ///@param  equation   方程字符串
  ///@param  map        存储变量与其对应序号的map
  ///@param  isLeft     传入方程是否是等式左边
  ///@param  index      处理的是哪一行的方程
  simplifiedEquation(String equation, Map map, bool isLeft, int index) {  //a+b
    RegExp reg = new RegExp(r'(\+|-)\w+');
    if(RegExp(r'^[A-Za-z0-9]').hasMatch(equation)){
      equation = '+' + equation;
    }   //+a+b
    var mas = reg.allMatches(equation);
    for (var m in mas) {
      var indexNum = m.group(0).indexOf(RegExp('[A-Za-z]'));
      if (indexNum > 0) {
        var postStr = m.group(0).substring(0, indexNum);
        if (postStr == '-' || postStr == '+') {
          postStr = postStr + '1';
        }
        var postNum;
        try {
          postNum = num.parse(postStr);
        } catch (e) {
          throw FormatException('系数输入有误');
        }
        if (!isLeft) {
          postNum = postNum * (-1);
        }
        String varStr = m.group(0).substring(indexNum);
        if (!map.containsKey(varStr)) {
          throw FormatException('符号$varStr 未记录在变量列表中');
        }
        var mapindex = map[varStr];
        postMatrix[index][mapindex] = postNum;
      }else {
        var postNum;
        try {
          postNum = num.parse(m.group(0));
        } catch (e) {
          throw FormatException('${m.group(0)} 输入有误');
        }
        if (isLeft) {
          postNum *= -1;
        }
        constant[index][0] = constant[index][0] + postNum;
      }
    }
  }

  ///传入非线性方程，返回结果
  ///@param   equation    非线性方程组
  ///@param   x           变量
  String nonlinearEquation(String equation, String x){
    String result;
    Function fun = (x) {};
    if(equation.substring(0,1) != '-'){
      equation = '+' + equation;
    }
    var reg = new RegExp(r'(\+|-)[0-9]*' + x + r'(\^[0-9]+)?');
    var mas = reg.allMatches(equation);
    for(var m in mas){
      var x_i = m.group(0).indexOf(x);
      if(m.group(0).contains('^')){
        var power_i = m.group(0).indexOf('^');
        var post = num.parse(m.group(0).substring(0,x_i));
        var power = num.parse(m.group(0).substring(power_i + 1));
        var newfun = (x) => fun(x) + post * pow(x, power);
        fun = newfun;
      }

    }
    return result;
  }
}


