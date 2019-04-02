import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiaoming/src/data/appData.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';
import 'package:xiaoming/src/command/handleCommand.dart';

class NewMethodRoute extends StatefulWidget {
  @override
  _NewMethodRouteState createState() => _NewMethodRouteState();
}

class _NewMethodRouteState extends State<NewMethodRoute> {
  TextEditingController _funName;
  TextEditingController _parm;
  TextEditingController _cmds;

  @override
  void initState() {
    _funName = new TextEditingController();
    _parm = new TextEditingController();
    _cmds = new TextEditingController();
    UserData.nowPage = 3;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isPop = false;
    UserData.pageContext = context;
    void _saveMethod() {
        if (_funName.text.length != 0 || _parm.text.length != 0 || _cmds.text.length > 1){
          if (!_funName.text.contains(RegExp(r'[^A-Za-z0-9]'))){
            if (!_parm.text.contains(RegExp(r'[^A-Za-z,]'))) {
              showCupertinoDialog(
                  context: context,
                  builder: (alertContext) {
                    return CupertinoAlertDialog(
                      title: Text(XiaomingLocalizations.of(context).sucSave),
                      actions: <Widget>[
                        CupertinoActionSheetAction(
                          child: Text(XiaomingLocalizations.of(context).ok),
                          isDestructiveAction: true,
                          onPressed: () {
                            isPop = true;
                            UserFunction uf = new UserFunction(
                                _funName.text, _parm.text.split(','), _cmds.text.split(';'));
                            if(isUserFun(_funName.text)){
                              UserData.userFunctions.remove(getUfByName(_funName.text));
                              UserData.deleteUF(_funName.text);
                            }
                            UserData.userFunctions.add(uf);
                            UserData.addUF(uf.funName, uf.paras, uf.funCmds);
                            Navigator.pop(alertContext);
                          },
                        ),
                        CupertinoActionSheetAction(
                          child: Text(XiaomingLocalizations.of(context).cancel),
                          onPressed: () {
                            Navigator.pop(alertContext);
                          },
                        ),
                      ],
                    );
                  }).then((value){
                    if(isPop){
                      Navigator.pop(context);
                    } 
                  });
            }
          }
        }else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: Text('请输入函数名，函数参数，函数体'),
                actions: <Widget>[],
              );
            }
          );
        }
    }

    return DefaultTextStyle(
      style: const TextStyle(
        fontFamily: '.SF UI Text',
        inherit: false,
        fontSize: 17.0,
        color: CupertinoColors.black,
      ),
      child: CupertinoPageScaffold(
        backgroundColor: CupertinoColors.lightBackgroundGray,
        navigationBar: CupertinoNavigationBar(
          middle: Text(XiaomingLocalizations.of(context).newFun),
          previousPageTitle: 'Saved',
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 60.0, vertical: 20.0),
                child: CupertinoTextField(
                  placeholder: 'Method Name',
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: CupertinoColors.activeBlue,
                      width: 0.0,
                    ),
                  ),
                  controller: _funName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 60.0, vertical: 20.0),
                child: CupertinoTextField(
                  placeholder: 'Method Parameter',
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: CupertinoColors.activeBlue,
                      width: 0.0,
                    ),
                  ),
                  controller: _parm,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 60.0, vertical: 20.0),
                child: CupertinoTextField(
                  placeholder: 'Method body',
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: CupertinoColors.activeBlue,
                      width: 0.0,
                    ),
                  ),
                  controller: _cmds,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.all(20),
                  child: Center(
                    child: CupertinoButton(
                      child: Text(
                        XiaomingLocalizations.of(context).save,
                        // style: TextStyle(
                        //   color: Colors.blue,
                        //   fontStyle: FontStyle.italic,
                        //   fontSize: 24,
                        // ),
                      ),
                      onPressed: () => _saveMethod(),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
