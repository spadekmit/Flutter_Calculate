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
      'equaHint1':
          'A linear equation is one or more equations whose highest power is one',
      'equaHint2': 'Example a00x + + a02z a01y = b0, a10x + + a12z a11y = b1,',
      'equaHint3': 'a20x +a21y+a22z=b2 ',
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
          'The format of the matrix assignment statement is: a=[1,2,3;4,5,6;7,8,9], the name can consist of letters and numbers, but must start with a letter.'
          'Multiple values for each line are separated by commas, separated by semicolons. Above the input box is a comma and semicolon button for easy entry. The matrix and real numbers are automatically saved to the file, and the data with the same name will be replaced (enter a=2 will also replace the original a=[1,2,3;4,5,6]',
      'HelpTabData2':
          "The function can be called by entering the function name and its parameters. Example: b=inv(a). Functions can be nested,Example: c=tran(inv(a)). The built-in function can also be called in the custom function. There is a button column at the top of the input box to facilitate the input of the function nameClick the button in the upper left corner of the main interface to open the drawer. Click the saved function button in the drawer to open the function introduction interface, which has built-in functions.Details, as well as the user's custom function",
      'HelpTabData3':
          "Example: Fun test(a,b,c):d=a*b/(b+c);r=factorial(d) A custom function can consist of multiple command statements or a single command statement, multiple command statements Separated by semicolons, the last command is the result of the function. The custom function will be saved in the file for the next time, and the custom function with the same name will only retain the newly defined function. The custom function name cannot be the name of a built-in function. Pass in the argument when calling the custom function, for example: test(3,2,-1). Note: The factorial function used in the example automatically rounds the fractional part to an integer and then multiplies the factorial.",
      'HelpTabData4':
          'Click the Settings button in the drawer interface to jump to the settings interface, and slide the slider to select the number of decimals to the decimal point.',
      'HelpTabData5':
          'In the drawer interface, there is a button to solve equations, click to enter the interface to solve equations, input a single equation is regarded as polynomial solution to solve all roots, multiple equations are regarded as linear equations to solve.Since there is no convenient input bar in the interface of solving the equation, it is recommended to solve it in the main interface.Linear equations can be solved by using inva *b for inputting coefficient matrix a and constant sequence b, polynomials can be solved by using roots (p) for all roots.P is the coefficient column. See the saved function interface for detailed usage',
      'HelpTabData6':
          'First with a Fun t (x) : r = 2 * x ^ 3 to 7 * x defined integrand, then use the calculus dissuade (t, 0, 8) function to solve, t for the integrand, 0 to 8 for the integral interval',
      'Hint': 'Hint',
      'InputHint': 'Input command',
      'IntegralFunction' : 'Integral Function',
      'IntegralVariable' : 'Variable Of Integration',
      'IntegralRange' : 'Integrating Range',
      'maximum' : 'Maximum number of saves',
      'methodBody' : 'method body',
      'newFun' : 'New Funtion',
      'ok' : 'OK',
      'parameter' : 'parameter',
      'removeUF' : 'UserFuntion has been removed',
      'removeData' : 'Data has been removed',
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
      'equaHint1': '线性方程指最高次幂为1次的一元或多元方程',
      'equaHint2': '例a00x+a01y+a02z=b0,a10x+a11y+a12z=b1,',
      'equaHint3': 'a20x+a21y+a22z=b2      变量栏输入x,y,z',
      'equaHint4': '多项式指一元多次方程',
      'equaHint5': "例：'x^2-2x+1' ,变量栏输入x",
      'funName' : '函数名',
      'Hint': '提示',
      'Help': '帮助',
      'HelpTab1': '数据输入',
      'HelpTab2': '计算',
      'HelpTab3': '函数',
      'HelpTab4': '精度',
      'HelpTab5': '方程',
      'HelpTabData1': '矩阵赋值的语句格式为：a=[1,2,3;4,5,6;7,8,9],'
          ' 名称可以由字母和数字组成,但必须以字母开头。'
          '每一行的多个值用逗号分隔开，行之间用分号分隔开。输入框的上方有方便输入的'
          '逗号和分号按钮。矩阵和实数会自动保存到文件，同名的数据会被替换（输入a=2也会替换'
          '原有的a=[1,2,3;4,5,6])',
      'HelpTabData2': '输入函数名及其参数即可调用函数。例：b=inv(a).函数可以嵌套调用，'
          '例：c=tran(inv(a)。在自定义函数中也可以调用内置函数，输入框的上方有方便输入函数名的按钮列'
          '点击主界面左上角的按钮可以打开抽屉，点击抽屉中的保存的函数按钮可以打开函数介绍界面，里面有内置函数的'
          '详细介绍，还有用户的自定义函数',
      'HelpTabData3':
          '示例： Fun test(a,b,c):d=a*b/(b+c);r=factorial(d)自定义函数可以由多个命令语句或单个命令语句组成，多个命令语句之间用'
          '分号分隔开，最后一条命令为函数的返回结果。自定义函数会保存在文件中，方便下次使用，同名的自定义函数只会保留最新定义的'
          '那个函数。自定义函数名不能为内置函数的名称。在调用自定义函数时传入参数， 例：test(3,2,-1)。注：示例中使用到的阶乘函数'
          '会自动将小数部分四舍五入成整数再求阶乘。',
      'HelpTabData4': '在抽屉界面中点击设置按钮可以跳转到设置界面，滑动滑块选择保留小数到小数点后第几位',
      'HelpTabData5':
          '在抽屉界面有解方程组按钮，点击可进入到解方程组的界面，输入单个方程则视为多项式解求所有根，多个方程则视为线性方程组求解。因解方程界面没有便捷输入栏，推荐在主界面解求。线性方程组可输入系数阵a和常数列b再用inv（a）*b即可解求，多项式可使用roots（p）解求所有根。p为系数列，详细用法见已保存的函数界面',
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
      'parameter' : '参数',
      'removeUF' : '自定义方法被移除',
      'removeData' : '数据被移除',
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

  get parameter {
    return _localizedValues[locale.languageCode]['parameter'];
  }

  get removeUF {
    return _localizedValues[locale.languageCode]['removeUF'];
  }

  get removeData {
    return _localizedValues[locale.languageCode]['removeData'];
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
