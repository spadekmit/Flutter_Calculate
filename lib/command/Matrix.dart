import 'package:xiaoming/data/data.dart';

String mtoString({String name, List<List<num>> list}) {
  StringBuffer buffer = new StringBuffer();
  if(name != null){
    buffer.write('$name = \n');
  }
  for (List<num> l in list) {
    for (num d in l) {
      buffer.write('   ');
      buffer.write(d.toStringAsFixed(fixedNum.round()) + '  ');
    }
    buffer.write("\n");
  }
  return buffer.toString();
}
///矩阵复制
List<List<num>> copyMatrix(List<List<num>> list){
  List<List<num>> newlist = [];
  int index = 0;
  for(List<num> l in list){
    newlist.add([]);
    for(num d in l){
      newlist[index].add(d);
    }
    index++;
  }
  return newlist;
}
/// 矩阵相乘
List<List<num>> m2mRide(List<List<num>> list1, List<List<num>> list2) {
  if (list1[0].length != list2.length) {
    throw FormatException("相乘矩阵的行列数不符合要求");
  }
  List<List<num>> newl = [];
  num sum = 0.0;
  for (int i = 0; i < list1.length; i++) {
    newl.add([]);
    for (int j = 0; j < list2[0].length; j++) {
      for (int k = 0; k < list2.length; k++) {
        sum += list1[i][k] * list2[k][j];
      }
      newl[i].add(sum);
      sum = 0.0;
    }
  }
  return newl;
}

/// 矩阵相减
List<List<num>> m2mMinus(
    List<List<num>> list1, List<List<num>> list2) {
  if (list1.length != list2.length || list1[0].length != list2[0].length) {
    throw FormatException("相减矩阵的行列数不符合要求");
  }
  List<List<num>> newl = [];
  for (int i = 0; i < list1.length; i++) {
    newl.add([]);
    for (int j = 0; j < list1[0].length; j++) {
      newl[i].add(list1[i][j] - list2[i][j]);
    }
  }
  return newl;
}

/// 矩阵相加
List<List<num>> m2mPlus(List<List<num>> list1, List<List<num>> list2) {
  if (list1.length != list2.length || list1[0].length != list2[0].length) {
    throw FormatException("相加矩阵的行列数不符合要求");
  }
  List<List<num>> newl = [];
  for (int i = 0; i < list1.length; i++) {
    newl.add([]);
    for (int j = 0; j < list1[0].length; j++) {
      newl[i].add(list1[i][j] + list2[i][j]);
    }
  }
  return newl;
}

/// 矩阵相除
List<List<num>> m2mDivide(
    List<List<num>> list1, List<List<num>> list2) {
  return m2mRide(list1, getAdjoint(list2));
}

/// 矩阵乘以一个浮点数
List<List<num>> m2dRide(List<List<num>> list1, num d) {
  List<List<num>> newl = [];
  for (int i = 0; i < list1.length; i++) {
    newl.add([]);
    for (int j = 0; j < list1[0].length; j++) {
      newl[i].add(list1[i][j] * d);
    }
  }
  return newl;
}

/// 矩阵除以一个浮点数
List<List<num>> m2dDivide(List<List<num>> list1, num d) {
  if (d == 0.0) {
    throw FormatException("除数不能为零");
  }
  List<List<num>> newl = [];
  for (int i = 0; i < list1.length; i++) {
    newl.add([]);
    for (int j = 0; j < list1[0].length; j++) {
      newl[i].add(list1[i][j] / d);
    }
  }
  return newl;
}

/// 矩阵加上一个浮点数
List<List<num>> m2dPlus(List<List<num>> list1, num d) {
  List<List<num>> newl = [];
  for (int i = 0; i < list1.length; i++) {
    newl.add([]);
    for (int j = 0; j < list1[0].length; j++) {
      newl[i].add(list1[i][j] + d);
    }
  }
  return newl;
}

/// 矩阵减去一个浮点数
List<List<num>> m2dMinus(List<List<num>> list1, num d) {
  List<List<num>> newl = [];
  for (int i = 0; i < list1.length; i++) {
    newl.add([]);
    for (int j = 0; j < list1[0].length; j++) {
      newl[i].add(list1[i][j] - d);
    }
  }
  return newl;
}

/// 判断矩阵是否为方阵
bool isSquare(List<List<num>> list) {
  if (list.length == list[0].length) {
    return true;
  }
  return false;
}

/// 获取给定行列式的值
num getDetValue(List<List<num>> list) {
  if (!isSquare(list)) throw FormatException('只有方阵才能求行列式的值');
  if (list.length == 2) {
    return list[0][0] * list[1][1] - list[0][1] * list[1][0];
  }
  var result = 0.0;
  int num = list.length;
  var nums = new List(num);
  for (int i = 0; i < list.length; i++) {
    if (i % 2 == 0) {
      nums[i] = list[0][i] * getDetValue(getConfactor(list, 0, i));
    } else {
      nums[i] = -list[0][i] * getDetValue(getConfactor(list, 0, i));
    }
  }
  for (int i = 0; i < list.length; i++) {
    result += nums[i];
  }
  return result;
}

/// 获取矩阵的逆阵
List<List<num>> getAdjoint(List<List<num>> list) {
  if (!isSquare(list)) throw FormatException('只有方阵才可逆');
  List<List<num>> newdata = [];
  //1阶方阵返回倒数
  if (list.length == 1) {
    newdata.add([]);
    newdata[0].add(1 / list[0][0]);
    return newdata;
  }
  num A = getDetValue(list);
  if (A == 0.0) throw FormatException('行列式的值为零的矩阵不能求逆');

  //2阶方阵直接求逆
  if (list.length == 2) {
    for (int i = 0; i < 2; i++) {
      newdata.add([]);
    }
    newdata[0].add(list[1][1]);
    newdata[0].add(-list[0][1]);
    newdata[1].add(-list[1][0]);
    newdata[1].add(list[0][0]);
    newdata = m2dDivide(newdata, A);
    return newdata;
  }
  for (int i = 0; i < list.length; i++) {
    newdata.add([]);
    for (int j = 0; j < list[0].length; j++) {
      if ((i + j) % 2 == 0) {
        newdata[i].add(getDetValue(getConfactor(list, i, j)) / A);
      } else {
        newdata[i].add(-getDetValue(getConfactor(list, i, j)) / A);
      }
    }
  }
  newdata = transList(newdata);
  return newdata;
}

/// 获取给定方阵中 （h,v）位置的代数余子式
List<List<num>> getConfactor(List<List<num>> list, int h, int v) {
  if (!(h < list.length)) {
    throw FormatException('h: $h 标签值越界  H: ${list.length}');
  } else if (!(v < list[0].length)) {
    throw FormatException('v: $v 标签值越界  V: ${list[0].length}');
  }
  List<List<num>> newlist = [];
  for (int i = 0; i < list.length; i++) {
    newlist.add([]);
    for (int j = 0; j < list[0].length; j++) {
      newlist[i].add(list[i][j]);
    }
  }
  newlist.removeAt(h);
  for (List<num> l in newlist) {
    l.removeAt(v);
  }
  return newlist;
}

/// 传入源矩阵，返回对应的转置矩阵
List<List<num>> transList(List<List<num>> list) {
  List<List<num>> newlist = [];
  for (int i = 0; i < list[0].length; i++) {
    newlist.add([]);
    for (int j = 0; j < list.length; j++) {
      newlist[i].add(list[j][i]);
    }
  }
  return newlist;
}

/// 获取传入矩阵的上三角矩阵
List<List<num>> upperTriangular(List<List<num>> list){
  var divisor = new List(list.length);
  int index = 0;
  for(int i=0;i<list.length;i++){
    for(int j=0;j<list.length;j++){
      if(list[index][index] == 0){
        var temp;
        for(int k=index +1;k<list.length;k++){
          if(list[k][index] != 0){
            temp = list[k];
            list[k] = list[index];
            list[index] = temp;
          }
        }
      }
      for(int k=index+1;k<list.length;k++){
        divisor[k] = list[k][index] / list[index][index];
      }

    }
  }
} 
///返回list除以d的结果
List<num> _listDivide(List<num> list, num d){
  var newlist = [];
  for(num n in list){
    newlist.add(n / d);
  }
  return newlist;
}
///返回list1减list2的结果
List<num> _listMinus(List<num> list1, List<num> list2){
  List newlist = [];
  if(list1.length != list2.length){
    throw FormatException('相减数组的长度不相等');
  }
  for(int i=0;i<list1.length;i++){
    newlist.add(list1[i] - list2[i]);
  }
  return newlist;
}