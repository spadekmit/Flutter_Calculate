import 'package:test/test.dart';
import 'package:xiaoming/command/handleCommand.dart';

void main(){
  test('test UserFunction invoke', () {
    print(handleCommand('Fun test(a,b,c):d=a*b/(b-c);r=factorial(d)'));
    expect(handleCommand('test(1,3,2)'), '6.000000');
  });
}