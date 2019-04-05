import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';

class IntegralRoute extends StatefulWidget {
  @override
  _IntegralRouteState createState() => _IntegralRouteState();
}

class _IntegralRouteState extends State<IntegralRoute>
    with TickerProviderStateMixin {
  var _dController;
  var _pController;
  var _animation;
  var _aController;
  var _iController;
  var _result = '';

  @override
  void initState() {
    _dController = TextEditingController();
    _pController = TextEditingController();
    _iController = TextEditingController();
    _aController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_aController);
    super.initState();
  }

  void verifyInputData() {
    if (_dController.text == null ||
        _pController.text == null ||
        _iController.text == null) {
      setState(() {
        _result = "积分函数，积分变量，积分区间都不能为空！";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        fontFamily: '.SF UI Text',
        inherit: false,
        fontSize: 17.0,
        color: CupertinoColors.black,
      ),
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(XiaomingLocalizations.of(context).definiteIntegral),
          previousPageTitle: "Functions",
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            child: Icon(CupertinoIcons.info),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 80.0,
              ),
              Container(
                //方程输入窗口
                padding: EdgeInsets.only(left: 12.0, bottom: 50.0),
                child: CupertinoTextField(
                  clearButtonMode: OverlayVisibilityMode.editing,
                  controller: _dController,
                  textCapitalization: TextCapitalization.words,
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 0.0, color: CupertinoColors.black)),
                  ),
                  placeholder: XiaomingLocalizations.of(context).integralFunction,
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 12.0,
                  bottom: 50.0,
                ),
                child: CupertinoTextField(
                  clearButtonMode: OverlayVisibilityMode.editing,
                  controller: _pController,
                  textCapitalization: TextCapitalization.words,
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 0.0, color: CupertinoColors.black)),
                  ),
                  placeholder: XiaomingLocalizations.of(context).integralVariable,
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 12.0,
                  bottom: 50.0,
                ),
                child: CupertinoTextField(
                  clearButtonMode: OverlayVisibilityMode.editing,
                  controller: _iController,
                  textCapitalization: TextCapitalization.words,
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 0.0, color: CupertinoColors.black)),
                  ),
                  placeholder: XiaomingLocalizations.of(context).integralRange + '  ps: 3,5',
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50.0,
                  vertical: 20.0,
                ),
                child: CupertinoButton(
                  color: Colors.blue,
                  onPressed: verifyInputData,
                  child: Text(XiaomingLocalizations.of(context).calculate),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 40.0),
                child: Center(
                  child: GestureDetector(
                    onLongPress: () {
                      Clipboard.setData(new ClipboardData(text: _result));
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              title: Text(
                                  XiaomingLocalizations.of(context).copyHint),
                            );
                          });
                    },
                    child: Text(
                      _result,
                      style: TextStyle(color: Colors.purple, fontSize: 20.0),
                    ),
                  ),
                ),
              ),
              FadeTransition(
                opacity: _animation,
                child: CupertinoButton(
                  child: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _result = "";
                      _aController.reverse();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dController.dispose();
    _pController.dispose();
    _aController.dispose();
    _iController.dispose();
    super.dispose();
  }
}
