import 'package:flutter/material.dart';
import '../deco/plan.dart';

class GasEdit extends StatefulWidget {
  final AppBar appBar;
  final Gas gas;
  final Function _save;
  final Segment segment;

  GasEdit({Key key, this.appBar, this.gas, this.segment, void save(Segment segment, Gas original, Gas changed)}) : _save = save, super(key: key);

  @override
  _GasEditState createState() => new _GasEditState(appBar, gas, _save, segment);
}

class _GasEditState extends State<GasEdit> {
  final AppBar _appBar;
  //final BottomNavigationBar _botNavBar;
  final Gas _gas;
  final TextEditingController _o2;
  final TextEditingController _he;
  bool _decoGas = false;
  final Segment _segment;
  var _save;

  _GasEditState(this._appBar, this._gas, this._save, this._segment):
        _o2 = new TextEditingController(text: "${(_gas.fO2*100).round()}"),
        _he = new TextEditingController(text: "${(_gas.fHe*100).round()}");

  @override
  Widget build(BuildContext context) {
    Column c3 = new Column(children: [
      new TextField(controller: _o2, decoration: new InputDecoration(labelText:  "O2 %:"), keyboardType: TextInputType.number),
      new TextField(controller: _he, decoration: new InputDecoration(labelText:  "He %:"), keyboardType: TextInputType.number),
      new Row(
        children: [new Checkbox(value: _decoGas, onChanged: (bool v) => setState(() {_decoGas = v;})), const Text('Deco Gas') ]
      ),
      new FlatButton(
        child: const Text('Save'),
        onPressed: () {
          Gas newGas = !_decoGas?new Gas.bottom(int.parse(_o2.text) / 100.0, int.parse(_he.text) / 100.0, 1.4):new Gas.deco(int.parse(_o2.text) / 100.0, int.parse(_he.text) / 100.0);
          _save(_segment, _gas, newGas);
        },
      ),
    ]);
    return new Scaffold(
      appBar: _appBar,
      body: c3,
      //bottomNavigationBar: _botNavBar,
      //floatingActionButton: _floatingActionButton,
    );
  }
}
