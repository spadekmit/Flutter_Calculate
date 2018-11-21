import 'package:xiaoming/command/matrix.dart';
import 'package:xiaoming/data/data.dart';

class EquationsUtil {
  _EquationsUtil() {}

  static final EquationsUtil instance = new EquationsUtil();
  static List<List<num>> postMatrix = [];
  static List<List<num>> constant = [];

  static EquationsUtil getInstance() {
    return instance;
  }

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
}
