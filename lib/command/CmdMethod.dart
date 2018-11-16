import 'dart:math';

///拉格朗日插值法
List<List<num>> lagrange(
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
num sum(List<List<num>> list) {
  num sum = 0.0;
  for (List<num> l in list) {
    for (num d in l) {
      sum += d;
    }
  }
  return sum;
}
///绝对值求和函数
num absSum(List<List<num>> list) {
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
num average(List<List<num>> list) {
  num average = sum(list) / (list.length * list[0].length);
  return average;
}
///求绝对值平均函数
num absAverage(List<List<num>> list) {
  num average = absSum(list) / (list.length * list[0].length);
  return average;
}
///求阶乘函数
num factorial(num d) {
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
num radToDeg(double rad) {
  return (rad / pi) * 180;
}
///格式化角度函数
String formatDeg(num deg) {
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
num reForDeg(num deg){
  var du = deg ~/ 1;
  var deci = deg - du;
  var fen = (deci * 100).floor();
  var miao = (deg * 10000 - (du * 10000 + fen * 100)).floor();
  return du + fen / 60 + miao / 6000;
}
///角度转弧度
num degToRad(num deg){
  var rad = deg / 180 * pi;
  return rad;
}

