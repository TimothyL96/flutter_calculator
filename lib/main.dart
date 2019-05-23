import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        buttonTheme: ButtonThemeData(
          height: 70,
          buttonColor: ThemeData.light().buttonColor,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: MyHomePage(title: 'A Not So Simple Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _onPress() {}

  Widget _button(String char) {
    return RaisedButton(
      onPressed: _onPress,
      child: Text(
        char,
        style: TextStyle(fontSize: 20),
      ),
      shape: CircleBorder(
        side:
            BorderSide(color: ThemeData.light().buttonColor, width: 2.1, style: BorderStyle.solid),
      ),
      elevation: 5,
    );
  }

  Widget _row(List<String> chars) {
    List<Widget> buttons = new List();
    for (var i = 0; i < chars.length; i++) {
      buttons.add(_button(chars[i]));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SafeArea(
          child: Container(
              color: ThemeData.light().backgroundColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // Row to display
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "Test",
                          style: TextStyle(fontSize: 34),
                        ),
                      ),
                    ],
                  ),
                  // Row for divider
                  Row(
                    children: <Widget>[
                      Expanded(
                          // Reimplement divider
                          child: SizedBox(
                        height: 3.0,
                        child: new Center(
                          child: new Container(
                            margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                            height: 3.0,
                            color: ThemeData.dark().buttonColor,
                          ),
                        ),
                      ))
                    ],
                  ),
                  // First row
                  _row(["1", "2", "3", "+"]),
                  // Second row
                  _row(["4", "5", "6", "-"]),
                  // Third row
                  _row(["7", "8", "9", "*"]),
                  // Fourth row
                  _row([".", "0", "=", "/"]),
                ],
              )),
        ));
  }
}
