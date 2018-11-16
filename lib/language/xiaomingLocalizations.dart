import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'dart:async';


class XiaomingLocalizations {

  final Locale locale;

  XiaomingLocalizations(this.locale);

  static Map<String, Map<String, String>> _localizedValues={
    'en' : {
      'AppName' : 'Account clerk',
      'Built-in function' : 'Built-in function',
      'Setting' : 'Setting',
      'Saved function' : 'Saved function',
      'Saved Data' : 'Saved Data',
      'InputHint' : 'Input command',
      'decimal digits' : 'decimal digits',
      'MethodButtonsView' : 'Built-in function shortcut input',
      'Horizontal' : 'isHorizontal',
    },
    'zh' : {
      'AppName' : '计算小秘书',
      'Built-in function': '内置的函数',
      'Setting' : '设置',
      'Saved function' : '保存的函数',
      'Saved Data' : '保存的数据',
      'InputHint' : '输入命令',
      'decimal digits' : '小数保留位数',
      'MethodButtonsView' : '内置函数快捷输入栏显示方式',
      'Horizontal' : '水平'
    }
  };

  get AppName{
    return _localizedValues[locale.languageCode]['AppName'];
  }
  get Built_in_function{
    return _localizedValues[locale.languageCode]['Built-in function'];
  }
  get Setting{
    return _localizedValues[locale.languageCode]['Setting'];
  }
  get Saved_function{
    return _localizedValues[locale.languageCode]['Saved function'];
  }
  get Saved_Data{
    return _localizedValues[locale.languageCode]['Saved Data'];
  }
  get InputHint{
    return _localizedValues[locale.languageCode]['InputHint'];
  }
  get decimal_digits{
    return _localizedValues[locale.languageCode]['decimal digits'];
  }
  get MethodButtonsView{
    return _localizedValues[locale.languageCode]['MethodButtonsView'];
  }
  get Horizontal{
    return _localizedValues[locale.languageCode]['Horizontal'];
  }

  static XiaomingLocalizations of(BuildContext context){
    return Localizations.of(context, XiaomingLocalizations);
  }
}

class XiaomingLocalizationsDelegate extends LocalizationsDelegate<XiaomingLocalizations>{
  const XiaomingLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // TODO: implement isSupported
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<XiaomingLocalizations> load(Locale locale) {
    // TODO: implement load
    return new SynchronousFuture<XiaomingLocalizations>(new XiaomingLocalizations(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<XiaomingLocalizations> old) {
    // TODO: implement shouldReload
    return false;
  }

  static XiaomingLocalizationsDelegate delegate = const XiaomingLocalizationsDelegate();

}