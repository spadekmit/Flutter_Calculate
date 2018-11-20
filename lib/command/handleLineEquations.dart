

class EquationsUtil{

  _EquationsUtil(){}

  static final EquationsUtil instance = new EquationsUtil();

  static EquationsUtil getInstance(){
    return instance;
  }


  String handleLineEquations(String raweuations,String rawvars){
    var equations = raweuations.split(',');
    var vars = rawvars.split(',');
    for(var equation in equations){
      var reg = RegExp(r'=');
      var matchs = reg.allMatches(equation);
      if(matchs.length != 1){
        throw FormatException('方程中等号数量错误');
      }
      var lr = equation.split('=');
      var leftEquation = lr[0];
      var rightEquation = lr[1];
    }
  }
}
