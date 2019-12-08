import 'package:SV_Vote/backend/backend.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secret Voting',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: MyHomePage(title: 'Secret Voting'),
      debugShowCheckedModeBanner: false,
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
  TextEditingController _ipAddressController =
      TextEditingController(text: '192.168.0.0');
  bool resetButtonVisible = false;
  int buttonPressedCount = 0;
  String commentText = '//', yesVotes = '0', noVotes = '0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          FlatButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: null,
              onPressed: () {
                buttonPressedCount++;
                if (buttonPressedCount % 5 == 0) {
                  setState(() {
                    resetButtonVisible = !resetButtonVisible;
                  });
                }
              })
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Row(
              children: <Widget>[
                Flexible(
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _ipAddressController,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: pingServer,
                    child: Text(
                      'PING',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
          resetButtonVisible
              ? Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                        onPressed: reset,
                        child: Text('Reset Votes'),
                        color: Colors.yellow),
                  ),
                )
              : SizedBox.shrink(),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(
                      child: Container(
                        height: 200,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(32))),
                        child: Center(
                          child: Text(
                            yesVotes == null ? 0 : yesVotes,
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white, fontSize: 48.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(
                      child: Container(
                        height: 200,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius:
                                BorderRadius.all(Radius.circular(32))),
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              noVotes == null ? 0 : noVotes,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 48.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              child: Text(
                commentText,
                style: TextStyle(fontSize: 32),
              ),
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: updateYes,
                      child: Text('Yes'),
                      color: Colors.green,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: updateNo,
                      child: Text('No'),
                      color: Colors.red,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                  onPressed: getVotes,
                  child: Text('Refresh Votes'),
                  color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }

  pingServer() {
    var response = Backend.ping(_ipAddressController.text);
    response.then((onValue) {
      if (onValue.statusCode == 200) {
        setState(() {
          commentText = '// Pong..';
        });
      } else {
        print(onValue);
        throw 'Not Accecpted';
      }
    }).catchError(networkError);
  }

  getVotes() {
    var response = Backend.getVotes(_ipAddressController.text);
    response.then((onValue) {
      if (onValue.statusCode == 200) {
        setState(() {
          yesVotes = json.decode(onValue.body)['yes_count'].toString();
          noVotes = json.decode(onValue.body)['no_count'].toString();
        });
      } else
        throw 'Not Accepted';
    }).catchError(networkError);
  }

  updateYes() {
    var response = Backend.updateYes(_ipAddressController.text);
    response.then((onValue) {
      if (onValue.statusCode == 200) {
        setState(() {
          commentText = '// Vote Successful';
        });
      } else
        throw 'Not Accepted';
    }).catchError(networkError);
    getVotes();
  }

  updateNo() {
    var response = Backend.updateNo(_ipAddressController.text);
    response.then((onValue) {
      if (onValue.statusCode == 200) {
        setState(() {
          commentText = '// Vote Successful';
        });
      } else
        throw 'Not Accepted';
    }).catchError(networkError);
    getVotes();
  }

  reset() {
    var response = Backend.resetVotes(_ipAddressController.text);
    response.then((onValue) {
      if (onValue.statusCode == 200) {
        setState(() {
          commentText = '// Reset done!';
        });
      } else
        throw 'Not Accepted';
    }).catchError(networkError);
    getVotes();
  }

  networkError(dynamic error) {
    print(error);
    setState(() {
      commentText = '// Something went wrong :(';
    });
  }
}
