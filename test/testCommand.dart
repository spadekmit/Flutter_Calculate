import 'package:flutter_test/flutter_test.dart';
import 'package:xiaoming/src/command/cmdMethod.dart';
import 'package:xiaoming/src/command/handleEquations.dart';
import 'package:xiaoming/src/command/matrix.dart';
import 'package:xiaoming/src/data/userData.dart';

void main() {
  final ud = new UserData();
  
  test('testEquation', () {
    var instance = EquationsUtil.getInstance();
    print(instance.handleEquation('1,-2,1'));
  });

  test('userFunction', () {
    String cmd = 'Fun test(x,y):x*y';
    print(ud.handleCommand(cmd));
    print(ud.handleCommand('test(3,4)'));
  });

  test('_formatCmdStr', (){
    String cmd = '-3x^2+2x/-1';
    print(ud.formatCmdStr(cmd));
  });

  test('handleCommand', (){
    print(ud.handleCommand('sin(-30)-20'));
  });

  test('Polyomial', (){
    expect(CmdMethodUtil.polyomial([[1,-2,1]]), [[1.0, -0.0], [1.0, 0.0]]);
  });

  test('calculus', (){
    ud.handleCommand('Fun test(x): r = 3*x ^ 2');
    expect(ud.handleCommand('calculus(test,0,4)'), '64.000000');
  });

  test('test getHessenberg', (){
    List<List<num>> matrix = [[4,1,0],[1,0,-1],[1,1,-4]];
    var result = MatrixUtil.getHessenberg(matrix);
    expect(result, [[4, 1.0, 0], [1, -1.0, -1], [0.0, -2.0, -3.0]]);
  });

  test('test EigenValue', (){
    List<List<num>> matrix = [[0,12,-16],[1,0,0],[0,1,0]];
    expect(MatrixUtil.eigenValue(matrix, 400, 4),
     [[-3.999999923299447, 0.0],
      [1.9999999616497233,-0.00006904586138525003],
        [1.9999999616497233, 0.00006904586138525003]]);
  });

  test('test handleCaculStr', () {
    var result = ud.handleCalcuStr('-2+4*(-3+4)');
    expect(result, 2);
  });

  test('test upperTriangular function', () {
    var a = [
      [1, 1, 5, 3, 2],
      [2, 3, 2, 5, 7],
      [6, 4, 2, 5, 3],
      [3, 5, 2, 3, 2],
      [3, 2, 2, 1, 6]
    ];
    expect(MatrixUtil.upperTriangular(a), [
      [1, 1, 5, 3, 2],
      [0.0, 0.5, -4.0, -0.5, 1.5],
      [0.0, 0.0, 11.0, 3.7499999999999996, 0.7499999999999996],
      [0.0, 0.0, 0.0, -18.416666666666654, -37.41666666666665],
      [0.0, 0.0, 0.0, 0.0, 81.753086419753]
    ]);
  });

  test('test getResult function', () {
    var a = [
      [1, 1, 1, 6],
      [0, 4, -1, 5],
      [2, -2, 1, 1]
    ];
    expect(MatrixUtil.getResult(MatrixUtil.upperTriangular(a)), [1.0, 2.0, 3.0]);
  });
}
