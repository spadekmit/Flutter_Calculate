import 'package:flutter_test/flutter_test.dart';
import 'package:xiaoming/src/command/handleLineEquations.dart';
import 'package:xiaoming/src/command/matrix.dart';

void main(){
  test('test UserFunction invoke', () {
    var a = [[1,1,5,3,2],[2,3,2,5,7],[6,4,2,5,3],[3,5,2,3,2],[3,2,2,1,6]];
    var b = [[2], [5]];
    var instance = EquationsUtil.getInstance();
    print(mtoString(name: "B", list :upperTriangular(a)));
  });

  test('test upperTriangular function', () {
    var a = [[1,1,5,3,2],[2,3,2,5,7],[6,4,2,5,3],[3,5,2,3,2],[3,2,2,1,6]];
    expect(upperTriangular(a), [[1, 1, 5, 3, 2], [0.0, 0.5, -4.0, -0.5, 1.5], [0.0, 0.0, 11.0, 3.7499999999999996, 0.7499999999999996], [0.0, 0.0, 0.0, -18.416666666666654, -37.41666666666665], [0.0, 0.0, 0.0, 0.0, 81.753086419753]]);
  });

  test('test getResult function', () {
    var a = [[1,1,1,6],[0,4,-1,5],[2,-2,1,1]];
    expect(getResult(upperTriangular(a)), [1.0, 2.0, 3.0]);
  });
}