import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      title: 'Caesar Cipher',
      home: CaesarCipher(),
    );
  }
}

class CaesarCipher extends StatefulWidget {
  @override
  _CaesarCipherState createState() => _CaesarCipherState();
}

class _CaesarCipherState extends State<CaesarCipher> {
  TextEditingController _wordController = TextEditingController();
  TextEditingController _keyController = TextEditingController();
  String _result = "";

  @override
  void dispose() {
    _wordController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Caesar Cipher'),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Input your text here',
                  ),
                  controller: _wordController,
                  keyboardType: TextInputType.text,
                ),
                Container(
                  height: 32.0,
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Input your key'),
                  controller: _keyController,
                  keyboardType: TextInputType.number,
                ),
                Container(
                  height: 32.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    RaisedButton(
                      child: Text("Encrypt"),
                      onPressed: () {
                        this._process(true);
                      },
                      color: Colors.green,
                    ),
                    RaisedButton(
                      child: Text("Decrypt"),
                      onPressed: () {
                        this._process(false);
                      },
                    ),
                    RaisedButton(
                      child: Text("Delete"),
                      onPressed: _delete,
                      color: Colors.red,
                    ),
                  ],
                ),
                Container(
                  height: 64.0,
                ),
                Text(
                  'Output :',
                  style: TextStyle(fontSize: 24.0),
                  textAlign: TextAlign.center,
                ),
                Container(
                  height: 32.0,
                ),
                SelectableText(
                  _result,
                  style: TextStyle(fontSize: 32.0),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Made with Flutter by Rizki Maulana, Github : rmRizki',
            ),
          )
        ],
      ),
    );
  }

  void _process(bool _isEncrypt) {
    String _text = _wordController.text;
    int _key;
    String _temp = "";

    try {
      _key = int.parse(_keyController.text);
    } catch (e) {
      _showAlert("Invalid Key");
    }

    for (int i = 0; i < _text.length; i++) {
      int ch = _text.codeUnitAt(i);
      int offset;
      String h;
      if (ch >= 'a'.codeUnitAt(0) && ch <= 'z'.codeUnitAt(0)) {
        offset = 97;
      } else if (ch >= 'A'.codeUnitAt(0) && ch <= 'Z'.codeUnitAt(0)) {
        offset = 65;
      } else if (ch == ' '.codeUnitAt(0)) {
        _temp += " ";
        continue;
      } else {
        _showAlert("Invalid Text");
        _temp = "";
        break;
      }

      int c;
      if (_isEncrypt) {
        c = (ch + _key - offset) % 26;
      } else {
        c = (ch - _key - offset) % 26;
      }
      h = String.fromCharCode(c + offset);
      _temp += h;
    }

    setState(() {
      _result = _temp;
    });
  }

  void _delete() {
    _wordController.clear();
    _keyController.clear();
    setState(() {
      _result = "";
    });
  }

  Future<void> _showAlert(String _alert) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Something is Wrong'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(_alert),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
