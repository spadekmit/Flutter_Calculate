import 'package:xiaoming/src/data/settingData.dart';
import 'dart:math';

class MatrixUtil {
  static String mtoString({String name, List<List<num>> list}) {
    StringBuffer buffer = new StringBuffer();
    if (name != null) {
      buffer.write('$name = \n');
    }
    for (List<num> l in list) {
      for (num d in l) {
        if (d == 0.0) {
          d = 0.0;
        }
        buffer.write('   ');
        buffer.write(d.toStringAsFixed(SettingData.fixedNum.round()) + '  ');
      }
      buffer.write("\n\n");
    }
    var result = buffer.toString();
    result = result.substring(0,result.length - 2);
    return result;
  }

  ///矩阵复制
  static List<List<num>> copyMatrix(List<List<num>> list) {
    List<List<num>> newlist = [];
    int index = 0;
    for (List<num> l in list) {
      newlist.add([]);
      for (num d in l) {
        newlist[index].add(d);
      }
      index++;
    }
    return newlist;
  }

  /// 矩阵相乘
  static List<List<num>> m2mRide(List<List<num>> list1, List<List<num>> list2) {
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
  static List<List<num>> m2mMinus(
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
  static List<List<num>> m2mPlus(List<List<num>> list1, List<List<num>> list2) {
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
  static List<List<num>> m2mDivide(
      List<List<num>> list1, List<List<num>> list2) {
    return m2mRide(list1, getAdjoint(list2));
  }

  /// 矩阵乘以一个浮点数
  static List<List<num>> m2dRide(List<List<num>> list1, num d) {
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
  static List<List<num>> m2dDivide(List<List<num>> list1, num d) {
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
  static List<List<num>> m2dPlus(List<List<num>> list1, num d) {
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
  static List<List<num>> m2dMinus(List<List<num>> list1, num d) {
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
  static bool isSquare(List<List<num>> list) {
    if (list.length == list[0].length) {
      return true;
    }
    return false;
  }

  /// 获取给定行列式的值
  static num getDetValue(List<List<num>> list) {
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
  static List<List<num>> getAdjoint(List<List<num>> list) {
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
  static List<List<num>> getConfactor(List<List<num>> list, int h, int v) {
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
  static List<List<num>> transList(List<List<num>> list) {
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
  static List<List<num>> upperTriangular(List<List<num>> list) {
    //(n-1)!*2n  (n-1)!n
    var newlist = copyMatrix(list); //拷贝出一个新矩阵
    var divisor = new List(list.length); //用于记录对角线下的每一行的倍数
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
  static List<num> _listDivide(List<num> list, num d, int index) {
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
  static List<num> _listMinus(List<num> list1, List<num> list2) {
    List<num> newlist = [];
    if (list1.length != list2.length) {
      throw FormatException('相减数组的长度不相等');
    }
    for (int i = 0; i < list1.length; i++) {
      newlist.add(list1[i] - list2[i]);
    }
    return newlist;
  }

  ///传入上三角增广矩阵，输出结果列
  static List<num> getResult(List<List<num>> list) {
    final n = list.length; //矩阵行数
    List<num> result = []; //存储结果列
    for (int i = 0; i < n; i++) {
      var minus = 0.0;
      int index = n - 1 - i; // 当前所求解的行号
      for (int j = index + 1; j < n; j++) {
        minus += list[index][j] * result[n - j - 1]; //系数阵中的常数项之和
      }
      result.add((list[index][n] - minus) / list[index][index]);
    }
    List<num> newresult = []; //将结果列反转回正确的顺序
    for (int i = 0; i < result.length; i++) {
      newresult.add(result[result.length - i - 1]);
    }
    return newresult;
  }
  ///求绝对值
  static num _abs(num d) {
    return d > 0 ? d : -d;
  }
  ///初始化一个m行n列的矩阵
  static List<List<num>> initMatrix(int m, int n) {
    List<List<num>> matrix = [];
    for (int i = 0; i < m; i++) {
      matrix.add(new List<num>(n));
    }
    return matrix;
  }
  ///将一般矩阵转化为上海森柏格矩阵
  static List<List<num>> getHessenberg(List<List<num>> matrix) {
    if(!isSquare(matrix)){
      throw FormatException('只有方阵才能转化为上海森柏格矩阵');
    }
    int n = matrix.length;
    var result = initMatrix(n, n);
    int i;
    int j;
    int k;
    num temp;
    int maxNu;
    n -= 1;
    for (k = 1; k <= n - 1; k++) {
      i = k - 1;
      maxNu = k;
      temp = _abs(matrix[k][i]);
      for (j = k + 1; j <= n; j++) {
        if (_abs(matrix[j][i]) > temp) {
          maxNu = j;
        }
      }
      result[0][0] = matrix[maxNu][i];
      i = maxNu;
      if (result[0][0] != 0) {
        if (i != k) {
          for (j = k - 1; j <= n; j++) {
            temp = matrix[i][j];
            matrix[i][j] = matrix[k][j];
            matrix[k][j] = temp;
          }
          for (j = 0; j <= n; j++) {
            temp = matrix[j][i];
            matrix[j][i] = matrix[j][k];
            matrix[j][k] = temp;
          }
        }
        for (i = k + 1; i <= n; i++) {
          temp = matrix[i][k - 1] / result[0][0];
          matrix[i][k - 1] = 0.0;
          for (j = k; j <= n; j++) {
            matrix[i][j] -= temp * matrix[k][j];
          }
          for (j = 0; j <= n; j++) {
            matrix[j][k] += temp * matrix[j][i];
          }
        }
      }
    }
    for (i = 0; i <= n; i++) {
      for (j = 0; j <= n; j++) {
        result[i][j] = matrix[i][j];
      }
    }
    return result;
  }

  static List<List<num>> eigenValue(List<List<num>> matrix, int loopNu, int erro) {
    if(!isSquare(matrix)) {
      throw FormatException('方阵才能求特征值');
    }
    int n = matrix.length;
    List<List<num>> result = initMatrix(n, 2);
    int i;
    int j;
    int k;
    int t;
    int m;
    List<List<num>> A = initMatrix(n, n);
    num newerro = pow(0.1, erro);
    num b;
    num c;
    num d;
    num g;
    num xy;
    num p;
    num q;
    num r;
    num x;
    num s;
    num e;
    num f;
    num z;
    num y;
    int loop1 = loopNu;
    A = getHessenberg(matrix); // 将方阵matrix转化成Hessenberg矩阵A
    m = n;
    while (m != 0) {
      t = m - 1;
      while (t > 0) {
        if (_abs(A[t][t - 1]) > newerro * (_abs(A[t - 1][t - 1]) + _abs(A[t][t]))) {
          t -= 1;
        } else {
          break;
        }
      }
      if (t == m - 1) {
        result[m - 1][0] = A[m - 1][m - 1];
        result[m - 1][1] = 0.0;
        m -= 1;
        loop1 = loopNu;
      } else if (t == m - 2) {
        b = -(A[m - 1][m - 1] + A[m - 2][m - 2]);
        c = A[m - 1][m - 1] * A[m - 2][m - 2] - A[m - 1][m - 2] * A[m - 2][m - 1];
        d = b * b - 4 * c;
        y = pow(_abs(d), 0.5);
        if (d > 0) {
          xy = 1;
          if (b < 0) {
            xy = -1;
          }
          result[m - 1][0] = -(b + xy * y) / 2;
          result[m - 1][1] = 0.0;
          result[m - 2][0] = c / result[m - 1][0];
          result[m - 2][1] = 0.0;
        } else {
          result[m - 1][0] = -b / 2;
          result[m - 2][0] = result[m - 1][0];
          result[m - 1][1] = y / 2;
          result[m - 2][1] = -result[m - 1][1];
        }
        m -= 2;
        loop1 = loopNu;
      } else {
        if (loop1 < 1) {
          return null;
        }
        loop1 -= 1;
        j = t + 2;
        while (j < m) {
          A[j][j - 2] = 0;
          j += 1;
        }
        j = t + 3;
        while (j < m) {
          A[j][j - 3] = 0;
          j += 1;
        }
        k = t;
        while (k < m - 1) {
          if (k != t) {
            p = A[k][k - 1];
            q = A[k + 1][k - 1];
            if (k != m - 2) {
              r = A[k + 2][k - 1];
            } else {
              r = 0;
            }
          } else {
            b = A[m - 1][m - 1];
            c = A[m - 2][m - 2];
            x = b + c;
            y = c * b - A[m - 2][m - 1] * A[m - 1][m - 2];
            p = A[t][t] * (A[t][t] - x) + A[t][t + 1] * A[t + 1][t] + y;
            q = A[t + 1][t] * (A[t][t] + A[t + 1][t + 1] - x);
            r = A[t + 1][t] * A[t + 2][t + 1];
          }
          if (p != 0 || q != 0 || r != 0) {
            if (p < 0) {
              xy = -1;
            } else {
              xy = 1;
            }
            s = xy * pow(p * p + q * q + r * r, 0.5);
            if (k != t) {
              A[k][k - 1] = -s;
            }
            e = -q / s;
            f = -r / s;
            x = -p / s;
            y = -x - f * r / (p + s);
            g = e * r / (p + s);
            z = -x - e * q / (p + s);
            for (j = k; j <= m - 1; j++) {
              b = A[k][j];
              c = A[k + 1][j];
              p = x * b + e * c;
              q = e * b + y * c;
              r = f * b + g * c;
              if (k != m - 2) {
                b = A[k + 2][j];
                p += f * b;
                q += g * b;
                r += z * b;
                A[k + 2][j] = r;
              }
              A[k + 1][j] = q;
              A[k][j] = p;
            }
            j = k + 3;
            if (j >= m - 1) {
              j = m - 1;
            }
            for (i = t; i <= j; i++) {
              b = A[i][k];
              c = A[i][k + 1];
              p = x * b + e * c;
              q = e * b + y * c;
              r = f * b + g * c;
              if (k != m - 2) {
                b = A[i][k + 2];
                p += f * b;
                q += g * b;
                r += z * b;
                A[i][k + 2] = r;
              }
              A[i][k + 1] = q;
              A[i][k] = p;
            }
          }
          k += 1;
        }
      }
    }
    return result;
  }
}


