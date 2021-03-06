import 'package:flutter/material.dart';
import 'widgets/int_edit.dart';
import 'widgets/common_form_buttons.dart';
import '../deco/dive.dart';
import '../deco/gas.dart';

class GasEdit extends StatefulWidget {
  final AppBar appBar;
  final Gas gas;
  final Function _save;
  final Dive dive;

  GasEdit(
      {Key key,
      this.appBar,
      this.gas,
      this.dive,
      void save(Dive dive, Gas original, Gas changed)})
      : _save = save,
        super(key: key);

  @override
  _GasEditState createState() => new _GasEditState(appBar, gas, _save, dive);
}

class _GasEditState extends State<GasEdit> {
  final AppBar _appBar;
  final Gas _gas;
  bool _decoGas;
  final Dive _dive;
  int _pO2;
  int _pHe;
  var _save;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      //_autovalidate = true;  // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      Gas newGas = !_decoGas
          ? new Gas.bottom(_pO2 / 100.0, _pHe / 100.0, 1.4)
          : new Gas.deco(_pO2 / 100.0, _pHe / 100.0);
      _save(_dive, _gas, newGas);
    }
  }

  _GasEditState(this._appBar, this._gas, this._save, this._dive)
      : _pO2 = (_gas.fO2 * 100).round(),
        _pHe = (_gas.fHe * 100).round(),
        _decoGas = (_gas.useAscent && !_gas.useDescent);

  @override
  Widget build(BuildContext context) {
    ListView c3 = new ListView(padding: const EdgeInsets.all(8.0), children: [
      new IntEdit(initialValue: _pO2,
          onSaved: (int v) => _pO2 = v,
          validator: (int v) => (v < 0 || v > 100)?"Enter O2 percent 0-100":null,
          label: "O2 %"),
      new IntEdit(initialValue: _pHe,
          onSaved: (int v) => _pHe = v,
          validator: (int v) => (v < 0 || v > 100)?"Enter He percent 0-100":null,
          label: "He %"),
      new Row(children: [
        new Checkbox(
            value: _decoGas,
            onChanged: (bool v) => setState(() {
              _decoGas = v;
            })),
        const Text('Deco Gas')
      ]),
      new CommonButtons(formKey: _formKey, submit: _handleSubmitted),
    ]);
    return new Scaffold(
      key: _scaffoldKey,
      appBar: _appBar,
      body: new Form(key: _formKey, child: c3),
    );
  }
}
