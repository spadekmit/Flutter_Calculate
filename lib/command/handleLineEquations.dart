

class EquationsUtil{

  _EquationsUtil(){}

  static final EquationsUtil instance = new EquationsUtil();

  static EquationsUtil getInstance(){
    return instance;
  }


  String handleLineEquations(String raweuations,String rawvars){
    String result = '';
    var equations = raweuations.split(',');
    var vars = rawvars.split(',');
    for(var equation in equations){
      var reg = RegExp(r'=');
      var matchs = reg.allMatches(equation);
      if(matchs.length != 1){
        return '方程中等号数量错误';
      }
      if(equation.contains(RegExp(r'\*|/'))){
        return '线性方程组不处理乘除运算';
      }
      var lr = equation.split('=');
      var leftEquation = lr[0];
      var rightEquation = lr[1];
      var vs = leftEquation.split(RegExp(r'\+|-'));
    }
    return result;
  }

  simplifiedEquation(String equation){
    var vs = equation.split(RegExp(r'\+|-|\*|/'));
  }
}
