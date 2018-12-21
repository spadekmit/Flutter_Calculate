import 'package:flutter/material.dart';
import 'package:xiaoming/src/data/settingData.dart';
import 'package:xiaoming/src/language/xiaomingLocalizations.dart';

typedef OnTapButton = void Function(String label);

class InputButtons extends StatefulWidget {
  InputButtons({@required this.isExpanded, @required this.onTapButton});

  bool isExpanded;
  OnTapButton onTapButton;

  @override
  _InputButtonsState createState() =>
      _InputButtonsState(onTapButton: onTapButton, isExpanded: isExpanded);
}

class _InputButtonsState extends State<InputButtons> {
  _InputButtonsState({@required this.isExpanded, @required this.onTapButton});

  bool isExpanded;
  OnTapButton onTapButton;

  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {

    Widget _buildTextButton(String label, {double width = 50.0}) {
       return LimitedBox(
        maxWidth: width,
        child: new FlatButton(
          padding: const EdgeInsets.all(0.0),
          onPressed: () => onTapButton(label),
          child: new Text(label, style: new TextStyle(fontSize: 14.0)),
        ),
      );
    }

    return ExpansionPanelList(
      expansionCallback: (int i, bool b) => setState(() {
            _isExpanded = !_isExpanded;
          }),
      children: <ExpansionPanel>[
        ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return new ListTile(
              leading: new Text(XiaomingLocalizations.of(context).buttons,
                  style: TextStyle(fontSize: 18.0, color: Colors.deepOrange)),
            );
          },
          isExpanded: _isExpanded,
          body: LimitedBox(
            maxHeight: SettingData.buttonsHeight,
            child: Column(children: <Widget>[
              Flexible(
                child: ListView(
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _buildTextButton('Fun', width: double.infinity),
                        _buildTextButton('inv(', width: double.infinity),
                        _buildTextButton('tran(', width: double.infinity),
                        _buildTextButton('value(', width: double.infinity),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _buildTextButton('upmat(', width: double.infinity),
                        _buildTextButton('cofa(', width: double.infinity),
                        _buildTextButton('calculus(', width: double.infinity),
                        _buildTextButton('roots(', width: double.infinity),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _buildTextButton('sum(', width: double.infinity),
                        _buildTextButton('average(', width: double.infinity),
                        _buildTextButton('factorial(', width: double.infinity),
                        _buildTextButton('sin(', width: double.infinity),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _buildTextButton('cos(', width: double.infinity),
                        _buildTextButton('tan(', width: double.infinity),
                        _buildTextButton('asin(', width: double.infinity),
                        _buildTextButton('acos(', width: double.infinity),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _buildTextButton('atan(', width: double.infinity),
                        _buildTextButton('formatDeg(', width: double.infinity),
                        _buildTextButton('reForDeg(', width: double.infinity),
                        _buildTextButton('absSum(', width: double.infinity),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _buildTextButton('absAverage(', width: double.infinity),
                        _buildTextButton('radToDeg(', width: double.infinity),
                        _buildTextButton('lagrange(', width: double.infinity),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(height: 1.0),
              LimitedBox(
                maxHeight: 40,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _buildTextButton(','),
                    _buildTextButton(';'),
                    _buildTextButton(':'),
                    _buildTextButton('['),
                    _buildTextButton('='),
                    _buildTextButton('('),
                  ],
                ),
              ),
              Divider(height: 1.0),
              LimitedBox(
                maxHeight: 40,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _buildTextButton('^'),
                    _buildTextButton('+'),
                    _buildTextButton('-'),
                    _buildTextButton('*'),
                    _buildTextButton('/'),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
