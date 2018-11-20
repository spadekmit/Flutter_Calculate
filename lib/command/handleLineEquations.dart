

class EquationsUtil{

  _EquationsUtil(){}

  static final EquationsUtil instance = new EquationsUtil();

  static EquationsUtil getInstance(){
    return instance;
  }


  String handleLineEquations(String raweuations,String rawvars){
    var equations = raweuations.split(',');
    var vars = rawvars.split(',');
    
  }
}
