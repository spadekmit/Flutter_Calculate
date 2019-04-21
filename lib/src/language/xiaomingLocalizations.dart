import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class XiaomingLocalizations {
  final Locale locale;

  XiaomingLocalizations(this.locale);

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'AppName': 'Computing assistant',
      'Buttons': 'Buttons',
      'ButtonsHeight' : 'Buttons Height',
      'ButtonsAutoExpanded' : 'ButtonsAutoExpanded',
      'calculate': 'calculate',
      'cancel' : 'cancel',
      'CopyHint': 'The content has been copied to the clipboard',
      'decimal digits': 'Decimal Digits',
      'delete' : 'delete',
      'deleteAllMessage' : 'Please confirm if you want to delete all message',
      'deleteAllData' : 'Please confirm if you want to delete all saved data and method',
      'definite integral' : 'Definite Integral',
      'empty': 'empty',
      'equations' : 'Equations',
      'equationNotEmpty' : 'Equations cannot be empty',
      'equationTip' : 'Tip: this page can be used to solve linear equations and higher-order unary equations',
      'equaHint1':
          'A linear equation is one or more equations whose highest power is one',
      'equaHint2': 'Example 3x-2y+z=2,3y+5z=8,',
      'equaHint3': 'Multiple equation are separated by commas， Parameter is x,y,z',
      'equaHint4':
          'Polynomials refer to equations of one variable multiple times',
      'equaHint5': "Example: x^2-2x+1",
      'funName' : 'method name',
      'Help': 'HELP',
      'HelpTab1': 'Data input',
      'HelpTab2': 'Calculator',
      'HelpTab3': 'Method',
      'HelpTab4': 'Precision',
      'HelpTab5': 'Equation',
      'HelpTabData1':
          'You can assign a value directly to a variable in the input box. '
          'eg: a = 12 or r = [1,2,3;4,5,6;7,8,9]'
          '(This statement creates a matrix of three rows and three columns). '
          'The format of the matrix assignment statement is: '
          'Variable name = [value, value. . . ; value, value. . . ]'
          'Names can consist of letters and numbers, but must start with a letter. '
          'Multiple values for each line are separated by commas, separated by semicolons. '
          'Above the input box is a comma and semicolon button for easy entry. '
          'Matrix and real numbers are automatically saved to the file, the same name data will be replaced'
          '(Enter a=2 will also replace the original a=[1,2,3;4,5,6])',
      'HelpTabData2':
          'This software supports addition, subtraction, multiplication and division between values, '
          'Matrix and value addition, subtraction, multiplication and division, '
          'Addition, subtraction, multiplication and division of matrices and matrices. '
          '(It must comply with the matrix operation rules, '
          'If you multiply two matrices,'
          'The number of columns in the previous matrix needs to be the same as the number of rows in the latter matrix.'
          'To calculate a matrix, you need to assign the matrix to a variable first,'
          'Use this variable name to participate in the operation'
          'eg: b = [1,2;3,1] c = b + 2',
      'HelpTabData3':
          'Enter the function name and its parameters to call the function. Example: b=inv(a). Functions can be nested, '
          'Example: c=tran(inv(a). The built-in function can also be called in the custom function. There is a button column at the top of the input box to facilitate the input of the function name'
          'Click the button in the upper left corner of the main interface to open the drawer. Click the saved function button in the drawer to open the function introduction interface, which has built-in functions.'
          'Detailed introduction, as well as the user\'s custom function. The format of the custom function is: Fun function name (parameter list, separated by commas): function body,'
          'Custom functions can consist of multiple command statements or a single command statement, multiple statements separated by semicolons'
          'Example: Fun test(a,b,c):d=a*b/(b+c);r=factorial(d)'
          'The last command is the result of the function. The custom function will be saved in the file for the next time, the custom function with the same name will only retain the latest definition'
          'That function. The custom function name cannot be the name of a built-in function. Pass in parameter when calling custom function'
          ', Example: test(3,2,-1). Note: The factorial function used in the example'
          'The decimal part will be automatically rounded to an integer and then factored. ',
      'HelpTabData4':
          'Click the Settings button on the main interface to open the settings interface, and slide the button to change the displayed decimal places.',
      'HelpTabData5':
          'There is a solution to the equations button on the drawer interface, click to enter the interface to solve the equations,'
          'Entering a single equation is considered as a polynomial solution for all roots, and multiple equations are treated as linear equations. '
          'There is no convenient input field for the solution of the equation. It is recommended to solve the problem on the main interface. '
          'Linear equations can be input to the coefficient matrix a and the constant column b and then solved by inv(a)*b, '
          'The polynomial can use roots(p) to solve all roots. p is the coefficient column. For detailed usage, see the saved function interface',
      'HelpTabData6':
          'First define the integrand with Fun t(x):r = 2*x^3-7*x, then solve it with calculus(t,0,8) function, t is the integrand, and 0 to 8 is the integration interval.',
      'Hint': 'Hint',
      'InputHint': 'Input command',
      'IntegralFunction' : 'Integral Function',
      'IntegralVariable' : 'Variable Of Integration',
      'IntegralRange' : 'Integrating Range',
      'maximum' : 'Maximum number of saves',
      'methodBody' : 'method body',
      'newFun' : 'New Funtion',
      'ok' : 'OK',
      'outApp' : 'Whether to quit the app?',
      'parameter' : 'parameter',
      'quit' : 'quit',
      'removeUF' : 'UserFuntion has been removed',
      'removeData' : 'Data has been removed',
      'sample' : 'Sample',
      'Setting': 'Setting',
      'save' : 'save',
      'Saved function': 'Saved function',
      'Saved Data': 'Saved Data',
      'Solve equation': 'Solve equation',
      'Solve calculus': 'Solve calculus',
      'sucSave' : 'successfully saved',
      'undo' : 'UNDO',
      'variable' : 'variable',
      'variableNotEmpty' : 'Variable cannot be empty',
    },
    'zh': {
      'AppName': '计算小助手',
      'Buttons': '按钮',
      'ButtonsHeight' : '按钮栏显示高度',
      'ButtonsAutoExpanded' : '按钮栏自动展开',
      'calculate': '计算',
      'cancel' : '取消',
      'CopyHint': '内容已复制到剪切板',
      'decimal digits': '小数保留位数',
      'delete' : '删除',
      'deleteAllMessage' : '请确认是否删除所有消息记录',
      'deleteAllData' : '请确认是否要删除所有已保存的数据和方法',
      'definite integral' : '定积分',
      'empty': '清空',
      'equations' : '方程',
      'equationNotEmpty' : '方程组不能为空',
      'equationTip' : '提示：本页面可求解线性方程组和一元高次方程',
      'equaHint1': '输入方程系数求结果',
      'equaHint2': '如： x^2-2x+1=0 则输入 1,-2,1',
      'equaHint3': '3x1+4x2-x3=6   x2-4x3=-3   2x1-3x2+x3=0',
      'equaHint4': '则输入 3,4,-1,6;0,1,-4,-3;2,-3,1,0',
      'equaHint5': "例：'x^2-2x+1' ,变量栏输入x",
      'funName' : '函数名',
      'Hint': '提示',
      'Help': '帮助',
      'HelpTab1': '数据输入',
      'HelpTab2': '计算',
      'HelpTab3': '函数',
      'HelpTab4': '精度',
      'HelpTab5': '方程',
      'HelpTabData1': '可以在输入框内直接将值赋值给一个变量。'
          '如： a = 12 或 r = [1,2,3;4,5,6;7,8,9]'
          '(该语句创建了一个三行三列的矩阵)。'
          '矩阵赋值的语句格式为：'
          '变量名 = [ 数值，数值 。。。；数值，数值。。。]'
          '名称可以由字母和数字组成,但必须以字母开头。'
          '每一行的多个值用逗号分隔开，行之间用分号分隔开。'
          '输入框的上方有方便输入的逗号和分号按钮。'
          '矩阵和实数会自动保存到文件，同名的数据会被替换'
          '（输入a=2也会替换原有的a=[1,2,3;4,5,6])',
      'HelpTabData2': '此软件支持数值之间的加减乘除计算，'
          '矩阵与数值的加减乘除运算，'
          '矩阵与矩阵的加减乘除运算。'
          '（须符合矩阵运算规则，'
          '如相乘的两矩阵，'
          '前一矩阵的列数需与后一矩阵的行数相同）'
          '计算矩阵时需先将矩阵赋值给某一变量，'
          '再用该变量名参与运算'
          '如： b = [1,2;3,1]  c = b + 2',
      'HelpTabData3':
          '输入函数名及其参数即可调用函数。例：b=inv(a).函数可以嵌套调用，'
          '例：c=tran(inv(a)。在自定义函数中也可以调用内置函数，输入框的上方有方便输入函数名的按钮列'
          '点击主界面左上角的按钮可以打开抽屉，点击抽屉中的保存的函数按钮可以打开函数介绍界面，里面有内置函数的'
          '详细介绍，还有用户的自定义函数。自定义函数的格式为： Fun 函数名（参数列表，用逗号分隔）：函数体，'
          '自定义函数可以由多个命令语句或单个命令语句组成，多条语句用分号分隔'
          '示例： Fun test(a,b,c):d=a*b/(b+c);r=factorial(d)'
          '最后一条命令为函数的返回结果。自定义函数会保存在文件中，方便下次使用，同名的自定义函数只会保留最新定义的'
          '那个函数。自定义函数名不能为内置函数的名称。在调用自定义函数时传入参数'
          '， 例：test(3,2,-1)。注：示例中使用到的阶乘函数'
          '会自动将小数部分四舍五入成整数再求阶乘。',
      'HelpTabData4': '在主界面点击设置按钮即可打开设置界面，滑动按钮即可改变显示的小数位数',
      'HelpTabData5':
          '在抽屉界面有解方程组按钮，点击可进入到解方程组的界面，'
          '输入单个方程则视为多项式解求所有根，多个方程则视为线性方程组求解。'
          '因解方程界面没有便捷输入栏，推荐在主界面解求。'
          '线性方程组可输入系数阵a和常数列b再用inv（a）*b即可解求，'
          '多项式可使用roots（p）解求所有根。p为系数列，详细用法见已保存的函数界面',
      'HelpTabData6':
          '首先用Fun t(x):r = 2*x^3-7*x 定义被积函数，然后使用calculus(t,0,8)函数求解，t为被积函数，0到8为积分区间',
      'InputHint': '输入命令',
      'IntegralFunction' : '积分函数',
      'IntegralVariable' : '积分变量',
      'IntegralRange' : '积分区间',
      'methodBody' : '函数体',
      'maximum' : '历史记录条数',
      'newFun' : '新的函数',
      'ok' : '确认',
      'outApp' : '是否退出应用？',
      'parameter' : '参数',
      'quit' : '退出',
      'removeUF' : '自定义方法被移除',
      'removeData' : '数据被移除',
      'sample' : '示例',
      'Setting': '设置',
      'save' : '保存',
      'Saved function': '保存的函数',
      'Saved Data': '保存的数据',
      'Solve equation': '解方程',
      'sucSave' : '保存成功',
      'undo' : '撤销',
      'variable' : '变量',
      'variableNotEmpty' : '变量不能为空',
    }
  };

  get appName {
    return _localizedValues[locale.languageCode]['AppName'];
  }

  get buttons {
    return _localizedValues[locale.languageCode]['Buttons'];
  }

  get buttonsHeight {
    return _localizedValues[locale.languageCode]['ButtonsHeight'];
  }

  get buttonsAutoExpanded {
    return _localizedValues[locale.languageCode]['ButtonsAutoExpanded'];
  }

  get calculate {
    return _localizedValues[locale.languageCode]['calculate'];
  }

  get cancel {
    return _localizedValues[locale.languageCode]['cancel'];
  }

  get copyHint {
    return _localizedValues[locale.languageCode]['CopyHint'];
  }

  get decimalDigits {
    return _localizedValues[locale.languageCode]['decimal digits'];
  }

  get delete {
    return _localizedValues[locale.languageCode]['delete'];
  }

  get deleteAllMessage {
    return _localizedValues[locale.languageCode]['deleteAllMessage'];
  }

  get deleteAllData {
    return _localizedValues[locale.languageCode]['deleteAllData'];
  }

  get definiteIntegral {
    return _localizedValues[locale.languageCode]['definite integral'];
  }

  get empty {
    return _localizedValues[locale.languageCode]['empty'];
  }

  get equationNotEmpty {
    return _localizedValues[locale.languageCode]['equationNotEmpty'];
  }

  get equations {
    return _localizedValues[locale.languageCode]['equations'];
  }

  get equationTip {
    return _localizedValues[locale.languageCode]['equationTip'];
  }

  get equaHint1 {
    return _localizedValues[locale.languageCode]['equaHint1'];
  }

  get equaHint2 {
    return _localizedValues[locale.languageCode]['equaHint2'];
  }

  get equaHint3 {
    return _localizedValues[locale.languageCode]['equaHint3'];
  }

  get equaHint4 {
    return _localizedValues[locale.languageCode]['equaHint4'];
  }

  get equaHint5 {
    return _localizedValues[locale.languageCode]['equaHint5'];
  }

  get funName {
    return _localizedValues[locale.languageCode]['funName'];
  }

  get hint {
    return _localizedValues[locale.languageCode]['Hint'];
  }

  get help {
    return _localizedValues[locale.languageCode]['Help'];
  }

  get helpTab1 {
    return _localizedValues[locale.languageCode]['HelpTab1'];
  }

  get helpTab2 {
    return _localizedValues[locale.languageCode]['HelpTab2'];
  }

  get helpTab3 {
    return _localizedValues[locale.languageCode]['HelpTab3'];
  }

  get helpTab4 {
    return _localizedValues[locale.languageCode]['HelpTab4'];
  }

  get helpTab5 {
    return _localizedValues[locale.languageCode]['HelpTab5'];
  }

  get helpTab6 {
    return _localizedValues[locale.languageCode]['HelpTab6'];
  }

  get helpTabData1 {
    return _localizedValues[locale.languageCode]['HelpTabData1'];
  }

  get helpTabData2 {
    return _localizedValues[locale.languageCode]['HelpTabData2'];
  }

  get helpTabData3 {
    return _localizedValues[locale.languageCode]['HelpTabData3'];
  }

  get helpTabData4 {
    return _localizedValues[locale.languageCode]['HelpTabData4'];
  }

  get helpTabData5 {
    return _localizedValues[locale.languageCode]['HelpTabData5'];
  }

  get helpTabData6 {
    return _localizedValues[locale.languageCode]['HelpTabData6'];
  }

  get historySaving {
    return _localizedValues[locale.languageCode]['HistorySaving'];
  }

  get inputHint {
    return _localizedValues[locale.languageCode]['InputHint'];
  }

  get integralFunction {
    return _localizedValues[locale.languageCode]['IntegralFunction'];
  }

  get integralVariable {
    return _localizedValues[locale.languageCode]['IntegralVariable'];
  }

  get integralRange {
    return _localizedValues[locale.languageCode]['IntegralRange'];
  }

  get maximum {
    return _localizedValues[locale.languageCode]['maximum'];
  }

  get methodBody {
    return _localizedValues[locale.languageCode]['methodBody'];
  }

  get newFun {
    return _localizedValues[locale.languageCode]['newFun'];
  }

  get ok {
    return _localizedValues[locale.languageCode]['ok'];
  }

  get outApp {
    return _localizedValues[locale.languageCode]['outApp'];
  }

  get parameter {
    return _localizedValues[locale.languageCode]['parameter'];
  }

  get quit {
    return _localizedValues[locale.languageCode]['quit'];
  }

  get removeUF {
    return _localizedValues[locale.languageCode]['removeUF'];
  }

  get removeData {
    return _localizedValues[locale.languageCode]['removeData'];
  }

  get sample {
    return _localizedValues[locale.languageCode]['sample'];
  }

  get savedFunction {
    return _localizedValues[locale.languageCode]['Saved function'];
  }

  get save {
    return _localizedValues[locale.languageCode]['save'];
  }

  get savedData {
    return _localizedValues[locale.languageCode]['Saved Data'];
  }

  String get setting {
    return _localizedValues[locale.languageCode]['Setting'];
  }

  get solveEquation {
    return _localizedValues[locale.languageCode]['Solve equation'];
  }

  get sucSave {
    return _localizedValues[locale.languageCode]['sucSave'];
  }

  get undo {
    return _localizedValues[locale.languageCode]['undo'];
  }

  get variable {
    return _localizedValues[locale.languageCode]['variable'];
  }

  get variableNotEmpty {
    return _localizedValues[locale.languageCode]['variableNotEmpty'];
  }

  static XiaomingLocalizations of(BuildContext context) {
    return Localizations.of(context, XiaomingLocalizations);
  }
}

class XiaomingLocalizationsDelegate
    extends LocalizationsDelegate<XiaomingLocalizations> {
  const XiaomingLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<XiaomingLocalizations> load(Locale locale) {
    return new SynchronousFuture<XiaomingLocalizations>(
        new XiaomingLocalizations(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<XiaomingLocalizations> old) {
    return false;
  }

  static XiaomingLocalizationsDelegate delegate =
      const XiaomingLocalizationsDelegate();
}
