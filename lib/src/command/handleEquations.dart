import 'package:xiaoming/src/command/matrix.dart';
import 'package:xiaoming/src/data/settingData.dart';

class EquationsUtil {

  static final EquationsUtil instance = new EquationsUtil();
  static List<List<num>> postMatrix = [];
  static List<List<num>> constant = [];
  ///获取已缓存的实例
  static EquationsUtil getInstance() {
    return instance;
  }
  ///处理方程计算，判断是
  String handleEquation(String equations, String xs){
    String result;
    if(equations.contains('^')){
      result = _nonlinearEquation(equations, xs);
    }else{
      result = _handleLineEquations(equations, xs);
    }
    return result;
  }
  ///传入线性方程组和变量求得结果
  ///@param raweuations  线性方程组，以逗号隔开
  ///@param rawvars      所有变量，以逗号隔开
  String _handleLineEquations(String raweuations, String rawvars) {
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
        _simplifiedEquation(leftEquation, varmap, true, equationIndex);
        _simplifiedEquation(rightEquation, varmap, false, equationIndex);
      }catch(e){
        return e.toString();
      }
      equationIndex++;
    }
    var resultList = MatrixUtil.m2mRide(MatrixUtil.getAdjoint(postMatrix), constant);
    var sb = new StringBuffer();
    for(int i=0;i<vars.length;i++){
      sb.write(vars[i] + ':   ' + resultList[i][0].toStringAsFixed(SettingData.fixedNum.round()));
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
  _simplifiedEquation(String equation, Map map, bool isLeft, int index) {  //a+b
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
  String _nonlinearEquation(String equation, String x){
    equation = equation.replaceAll(' ', '') + ' ';
    num c = 0;
    var map = new Map();
    if(equation.substring(0,1) != '-'){
      equation = '+' + equation;
    }
    var reg = new RegExp(r'(\+|-)[0-9]*' + x + r'(\^[0-9]+)?');
    var numReg = new RegExp(r'(\+|-)[0-9]+[^' + x + r']');
    var mas = reg.allMatches(equation);
    int maxPower = 0;
    ///获取每一项的系数和幂数
    for(var m in mas){
      var xi = m.group(0).indexOf(x);
      String postStr = m.group(0).substring(0, xi);
      if(postStr.length == 1){
        postStr += '1';
      }
      var post = num.parse(postStr);   //多项式系数
      var power;
      if(m.group(0).contains('^')) {
        var poweri = m.group(0).indexOf('^');
        power = num.parse(m.group(0).substring(poweri + 1));  //多项式幂数
        if (power > maxPower) {
          maxPower = power;
        }
      }else{
        power = 1;
      }
      if (map.containsKey(power)) {
        map[power] += post;
      } else {
        map[power] = post;
      }
    }
    var numMs = numReg.allMatches(equation);
    for(var m in numMs){
      num temp = num.tryParse(m.group(0));
      if(temp != null){
        c += temp;
      }
    }
    List<List<num>> matrix = MatrixUtil.initMatrix(maxPower, maxPower);
    ///将多项式的最高次幂项系数化为1
    matrix[0][maxPower - 1] = -(c / map[maxPower]);
    for(int i=maxPower - 1;i>0;i--){
      if(!map.containsKey(i)){
        map[i] = 0;
      }else{
        map[i] = map[i] / map[maxPower];
      }
      matrix[0][maxPower - i - 1] = -map[i];
    }
    for(int i=1;i<maxPower;i++){
      for(int j=0;j<maxPower;j++){
        if(i == j + 1){
          matrix[i][j] = 1;
        }else{
          matrix[i][j] = 0;
        }
      }
    }
    var resultMatrix = MatrixUtil.eigenValue(matrix, 400, SettingData.fixedNum.round());
    int index = 1;
    StringBuffer sb = new StringBuffer();
    for(var l in resultMatrix){
      sb.write('第$index 个解为： ${l[0].toStringAsFixed(SettingData.fixedNum.round())}');
      sb.write('\n');
      index++;
    }
    return sb.toString();
  }

}


