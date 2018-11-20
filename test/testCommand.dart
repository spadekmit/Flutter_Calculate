import 'package:flutter_test/flutter_test.dart';
import 'package:xiaoming/command/handleCommand.dart';

void main(){
  test('test UserFunction invoke', () {
    var list = '''a=
    [1,2,5;
    2,1,5;
    4,7,2]
    ''';
    print(handleCommand(list));
  });
}