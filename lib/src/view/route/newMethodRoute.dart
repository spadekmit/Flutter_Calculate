import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoming/src/data/appData.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';
import 'package:xiaoming/src/command/handleCommand.dart';

void popNewMethodRoute(BuildContext context){
  Navigator.of(context).push(new CupertinoPageRoute(builder: (context){
    return NewMethodRoute();
  }));
}

class NewMethodRoute extends StatefulWidget {
  @override
  _NewMethodRouteState createState() => _NewMethodRouteState();
}

class _NewMethodRouteState extends State<NewMethodRoute> {
  String _funName;
  String _parm;
  String _cmds;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    void _saveMethod() {
      _formKey.currentState.save();
      if (_funName != null || _parm != null || _cmds != null) {
        if (_funName.length != 0 || _parm.length != 0 || _cmds.length != 0) {
          if (!_funName.contains(RegExp(r'[^A-Za-z0-9]'))) {
            if (!_parm.contains(RegExp(r'[^A-Za-z,]'))) {
              showDialog(
                  context: context,
                  builder: (alertContext) {
                    return AlertDialog(
                      title: Text("保存成功"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("确认"),
                          onPressed: () {
                            UserFunction uf = new UserFunction(
                                _funName, _parm.split(','), _cmds.split(';'));
                            if(UFcontain(_funName)){
                              UserData.userFunctions.remove(getUfByName(_funName));
                            }
                            UserData.userFunctions.add(uf);
                            Navigator.of(context)
                              ..pop()
                              ..pop();
                          },
                        ),
                        FlatButton(
                          child: Text("取消"),
                          onPressed: () {
                            Navigator.pop(alertContext);
                          },
                        ),
                      ],
                    );
                  });
            }
          }
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("New Function"),
        elevation: 1.0,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Container(
                  //方程输入窗口
                  padding: EdgeInsets.only(left: 24.0, top: 82.0,right: 24.0),
                  child: TextFormField(
                    onSaved: (value) {
                      _funName = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return '请输入函数名';
                      }
                    },
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: XiaomingLocalizations.of(context).funName,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  //方程输入窗口
                  padding: EdgeInsets.only(left: 24.0, top: 32.0, right: 24.0),
                  child: TextFormField(
                    onSaved: (value) {
                      _parm = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return '请输入函数参数';
                      }
                    },
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: XiaomingLocalizations.of(context).parameter,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  //方程输入窗口
                  padding: EdgeInsets.only(left: 24.0, top: 32.0, right: 24.0),
                  child: TextFormField(
                    onSaved: (value) {
                      _cmds = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return '请输入函数体';
                      }
                    },
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: XiaomingLocalizations.of(context).methodBody,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Center(
                    child: FlatButton(
                      child: Text(
                        XiaomingLocalizations.of(context).save,
                        style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                          fontSize: 24,
                        ),
                      ),
                      onPressed: () => _saveMethod(),
                    ),
                  )

                )
              ],
            )),
      ),
    );
  }
}
