import 'package:xiaoming/src/data/data.dart';

String mtoString({String name, List<List<num>> list}) {
  StringBuffer buffer = new StringBuffer();
  if(name != null){
    buffer.write('$name = \n');
  }
  for (List<num> l in list) {
    for (num d in l) {
      if(d == 0.0){
        d = 0.0;
      }
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
List<List<num>> upperTriangular(List<List<num>> list){ //(n-1)!*2n  (n-1)!n
  var newlist = copyMatrix(list);//拷贝出一个新矩阵
  var divisor = new List(list.length); //记录对角线下的每一行的倍数
  int index = 0;
  for (int i = 0; i < newlist.length; i++) {
    if (newlist[i][i] == 0) {
      //如果该对角线上的元素为零，将最近的不为零的一行换上来
      var temp;
      for (int k = i + 1; k < newlist.length; k++) {
        if (newlist[k][i] != 0) {
          temp = newlist[k];
          newlist[k] = newlist[i];
          newlist[i] = temp;
        }
      }
    }
    for (int k = i + 1; k < newlist.length; k++) {
      if (newlist[k][i] == 0) {
        continue;
      }
      divisor[k] = newlist[k][i] / newlist[i][i]; //存储k行与i行首位的倍数
      newlist[k] =
          _listMinus(_listDivide(newlist[k], divisor[k], i), newlist[i]);
    }
  }
  return newlist;
} 
///返回list除以d的结果
List<num> _listDivide(List<num> list, num d, int index) {
  List<num> newlist = [];
  for (int i = 0; i < index; i++) {
    newlist.add(0);
  }
  for (int i = index; i < list.length; i++) {
    newlist.add(list[i] / d);
  }
  return newlist;
}
///返回list1减list2的结果
List<num> _listMinus(List<num> list1, List<num> list2){
  List<num> newlist = [];
  if(list1.length != list2.length){
    throw FormatException('相减数组的长度不相等');
  }
  for(int i=0;i<list1.length;i++){
    newlist.add(list1[i] - list2[i]);
  }
  return newlist;
}
///传入上三角增广矩阵，输出结果列
List<num> getResult(List<List<num>> list){
  final n = list.length; //矩阵行数
  List<num> result = []; //存储结果列
  for (int i = 0; i < n; i++) {
    var minus = 0.0; 
    int index = n - 1 - i; // 当前所求解的行号
    for (int j = index + 1; j < n; j++) {
      minus += list[index][j] * result[n -j - 1];  //系数阵中的常数项之和
    }
    result.add((list[index][n] - minus) / list[index][index]);
  }
  List<num> newresult = [];  //将结果列反转回正确的顺序
  for (int i = 0; i < result.length; i++) {
    newresult.add(result[result.length - i - 1]);
  }
  return newresult;
}