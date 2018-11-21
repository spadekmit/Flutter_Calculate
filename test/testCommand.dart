import 'package:flutter_test/flutter_test.dart';
import 'package:xiaoming/command/handleLineEquations.dart';
import 'package:xiaoming/command/Matrix.dart';

void main(){
  test('test UserFunction invoke', () {
    var a = [[1,1],[2,3]];
    var b = [[2], [5]];
    var instance = EquationsUtil.getInstance();
    print(instance.handleLineEquations('a+b=2,2a+3b=5', 'a,b'));
  });
}