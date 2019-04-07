import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'package:xiaoming/src/command/matrix.dart';
import 'package:xiaoming/src/data/appData.dart';
import 'package:xiaoming/src/data/settingData.dart';

class CmdMethodUtil {
  ///拉格朗日插值法
  static List<List<num>> lagrange(
      List<List<num>> xs, List<List<num>> ys, List<List<num>> rs) {
    List<num> results = [];
    List<num> value = [];
    num result = 0.0;
    if (xs.length != 1 ||
        ys.length != 1 ||
        rs.length != 1 ||
        xs[0].length != ys[0].length) {
      throw FormatException(
          'lagrange函数参数行列数不符合要求，节点x值和y值，所求值必须为单行。节点x值个数必须与y值个数相等');
    }
    for (int k = 0; k < rs[0].length; k++) {
      for (int i = 0; i < xs[0].length; i++) {
        num temp1 = 1.0;
        num temp2 = 1.0;
        for (int j = 0; j < xs[0].length; j++) {
          if (j == i) continue;
          temp1 *= (rs[0][k] - xs[0][j]);
          temp2 *= (xs[0][i] - xs[0][j]);
        }
        value.add(temp1 / temp2);
      }
      for (int i = 0; i < xs[0].length; i++) {
        result += ys[0][i] * value[i];
      }
      results.add(result);
      result = 0.0;
      value = [];
    }
    List<List<num>> list = [];
    list.add(results);
    return list;
  }

  ///求和函数
  static num sum(List<List<num>> list) {
    num sum = 0.0;
    for (List<num> l in list) {
      for (num d in l) {
        sum += d;
      }
    }
    return sum;
  }

  ///绝对值求和函数
  static num absSum(List<List<num>> list) {
    num sum = 0.0;
    for (List<num> l in list) {
      for (num d in l) {
        if (d > 0) {
          sum += d;
        } else {
          sum -= d;
        }
      }
    }
    return sum;
  }

  ///求平均函数
  static num average(List<List<num>> list) {
    num average = sum(list) / (list.length * list[0].length);
    return average;
  }

  ///求绝对值平均函数
  static num absAverage(List<List<num>> list) {
    num average = absSum(list) / (list.length * list[0].length);
    return average;
  }

  ///求阶乘函数
  static num factorial(num d) {
    int i = d.round();
    num result = 1.0;
    if (d < 0) {
      throw FormatException('负数没有阶乘');
    }
    if (d == 0) {
      return 1.0;
    }

    while (i != 1) {
      result *= i;
      i--;
    }
    return result;
  }

  ///弧度转角度
  static num radToDeg(double rad) {
    return (rad / pi) * 180;
  }

  ///格式化角度函数
  static String formatDeg(num deg) {
    String format;
    int du = (deg ~/ 1);
    var fen = (deg - du) * 60;
    var miao = (fen - (fen ~/ 1)) * 60;
    format = du.toString() +
        '°' +
        fen.floor().toString() +
        '′' +
        miao.floor().toString() +
        '″';
    return format;
  }

  ///反格式化角度
  static num reForDeg(num deg) {
    var du = deg ~/ 1;
    var deci = deg - du;
    var fen = (deci * 100).floor();
    var miao = (deg * 10000 - (du * 10000 + fen * 100)).floor();
    return du + fen / 60 + miao / 6000;
  }

  ///角度转弧度
  static num degToRad(num deg) {
    var rad = deg / 180 * pi;
    return rad;
  }
  
  
  static Future<dynamic> handleCalculate(UserFunction uf, num a, num b) async {
    final response = ReceivePort();
    await Isolate.spawn(_isolateCalculus, response.sendPort);
    final sendPort = await response.first;
    final answer = ReceivePort();
    sendPort.send([answer.sendPort, uf, a, b]);
    return answer.first;
  }

  static void _isolateCalculus(SendPort port) {
    final rPort = ReceivePort();
    port.send(rPort.sendPort);
    rPort.listen((message) async {
      final send = message[0] as SendPort;
      final uf = message[1] as UserFunction;
      final a = message[2] as num;
      final b = message[3] as num;
      send.send(await _calculus(uf, a, b));
    });
  }

  ///计算微积分（复合梯形公式）
  static Future<num> _calculus(UserFunction fx, num a, num b) async {
    num result = 0;
    if(fx.paras.length != 1){
      throw FormatException('被积分函数的参数只允许为一个');
    }
    if (a > b) {
      var temp = b;
      b = a;
      a = temp;
    }
    var loops = (b - a) * 1000;
    num h = (b - a) / loops;
    for (int i = 0; i < loops; i++) {
      num temp1 = a + i * h;
      num temp2 = a + (i + 1) * h;
      String r1Str = await fx.invoke(temp1.toString());
      String r2Str = await fx.invoke(temp2.toString());
      result += (_getValue(r1Str) + _getValue(r2Str)) / 2 * h;
    }
    return result;
  }
  
  ///抽取字符串中等号后面的数值
  static num _getValue(String valStr){
    var index = valStr.indexOf('=');
    var result;
    try{
      result = num.parse(valStr.substring(index + 1));
    }catch(e){
      throw FormatException('积分函数返回值只能为实数');
    }
    return result;
  }

  static List<List<num>> polyomial(List<List<num>> list){
    if(list.length != 1){
      throw FormatException('多项式求解函数参数应为单行矩阵');
    }
    int n = list[0].length - 1;
    List<List<num>> matrix = MatrixUtil.initMatrix(n, n);
    for(int i=0;i<n;i++){
      matrix[0][i] = -(list[0][i+1] / list[0][0]);
    }
    for(int i=1;i<n;i++){
      for(int j=0;j<n;j++){
        if(i == j + 1){
          matrix[i][j] = 1;
        }else{
          matrix[i][j] = 0;
        }
      }
    }
    return MatrixUtil.eigenValue(matrix, 400, SettingData.fixedNum.round());
  }
}
