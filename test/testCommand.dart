import 'package:flutter_test/flutter_test.dart';
import 'package:xiaoming/command/handleLineEquations.dart';

void main(){
  test('test UserFunction invoke', () {
    var instan = EquationsUtil.getInstance();
    print(instan.handleLineEquations('a+b=1,2a+3b=5', 'a,b'));
  });
}