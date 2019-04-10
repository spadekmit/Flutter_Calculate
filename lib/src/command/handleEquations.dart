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
  String handleEquation(String equations){
    String result;
    if(equations.contains(';')){
      result = _handleLineEquations(equations);
    }else {
      result = _nonlinearEquation(equations);
    }
    return result;
  }
  ///传入线性方程组和变量求得结果
  ///@param raweuations  线性方程组，以逗号隔开
  ///@param rawvars      所有变量，以逗号隔开
  String _handleLineEquations(String euationsStr) {
    String result = '';
    var equations = euationsStr.split(';');
    var length = equations[0].split(',').length;
    var postMatrix = <List<num>>[];
    var constant = <List<num>>[];
    try{
      for (int i = 0; i < equations.length; i++) {
        postMatrix.add(<num>[]);
        constant.add([]);
        var ns = equations[i].split(',');
        if(length != ns.length) return '第 ${i+1} 行参数数量与第一行不一致';
        for (int j = 0; j < ns.length; j++) {
          if (j != ns.length - 1){
            postMatrix[i].add(num.parse(ns[j]));
          }else {
            constant[i].add(num.parse(ns[j]));
          }
        }
      }
    }catch (e){
      return '系数阵输入有误';
    }

    var resultList = MatrixUtil.m2mRide(MatrixUtil.getAdjoint(postMatrix), constant);
    var sb = new StringBuffer();
    for(int i=0;i<resultList.length;i++){
      sb.write('第 ${i + 1} 个解为:   ' + resultList[i][0].toStringAsFixed(SettingData.fixedNum.round()));
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
  String _nonlinearEquation(String equation){
    var nums = equation.split(',');
    var list = <num>[];
    for(var n in nums) {
      var temp = num.tryParse(n);
      if(temp != null) {
        list.add(temp);
      } else {
        return "$n 不能被识别为数字";
      }
    }
    var maxPower = list.length - 1;
    List<List<num>> matrix = MatrixUtil.initMatrix(maxPower, maxPower);
    ///将多项式的最高次幂项系数化为1
    matrix[0][maxPower - 1] = -(list[list.length - 1] / list[maxPower]);
    for(int i=maxPower - 1;i>0;i--){
        list[i] = list[i] / list[maxPower];
      matrix[0][maxPower - i - 1] = -list[i];
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


