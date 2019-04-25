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
        if(length != ns.length) {
          if (SettingData.language == 'zh') return '第 ${i+1} 行参数数量与第一行不一致';
          else return 'The number of arguments in line ${i + 1} is inconsistent with that in line 1';
        } 
        for (int j = 0; j < ns.length; j++) {
          if (j != ns.length - 1){
            postMatrix[i].add(num.parse(ns[j]));
          }else {
            constant[i].add(num.parse(ns[j]));
          }
        }
      }
    }catch (e){
      if (SettingData.language == 'zh') return '系数阵输入有误';
          else return 'Coefficient matrix input error';
    }

    var resultList = MatrixUtil.m2mRide(MatrixUtil.getAdjoint(postMatrix), constant);
    var sb = new StringBuffer();
    for(int i=0;i<resultList.length;i++){
      sb.write(SettingData.language == 'zh' ? '第 ${i + 1} 个解为:   ' : 'The ${i + 1} solution is:  ' + resultList[i][0].toStringAsFixed(SettingData.fixedNum.round()));
      sb.write('\n');
    }
    result = sb.toString();
    postMatrix = [];
    constant = [];
    return result;
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
        return SettingData.language == 'zh' ? "$n 不能被识别为数字" : '$n cannot be identified as a number';
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
    var resultMatrix = MatrixUtil.eigenValue(matrix, 400, 9);
    int index = 1;
    StringBuffer sb = new StringBuffer();
    for(var l in resultMatrix){
      sb.write(SettingData.language == 'zh' ? '第$index 个解为： ' : 'The $index solution is:  ' + '${l[0].toStringAsFixed(SettingData.fixedNum.round())}');
      sb.write('\n');
      index++;
    }
    return sb.toString();
  }

}


