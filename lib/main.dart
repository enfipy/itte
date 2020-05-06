import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:itte/repository/dataRepository.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:device_info/device_info.dart';

import 'models/response.dart';
import 'pie.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Is this the end?',
      theme: ThemeData(
        fontFamily: 'Montserrat',
      ),
      home: NeumorphicTheme(
          usedTheme: UsedTheme.LIGHT,
          theme: NeumorphicThemeData(
            baseColor: Color(0xFFFFFFFF),
            intensity: 1.0,
            lightSource: LightSource.topLeft,
            depth: 6,
          ),
          child: MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @protected
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  String comment = '';
  bool toRender = false;
  bool selectedValue;
  final DataRepository repository = DataRepository();
  double yes = 1;
  double no = 1;

  @override
  void initState() {
    _getUniqueId().then((id) {
      repository
          .getMyResponse(id)
          .listen((data) => data.documents.forEach((doc) {
                setState(() {
                  selectedValue = doc["value"];
                });
              }));
      setState(() {
        toRender = true;
      });
    });
    repository.counts().then((DocumentSnapshot ds) {
      yes = ds['yes'].toDouble();
      no = ds['no'].toDouble();
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: SlidingUpPanel(
        minHeight: selectedValue == null ? 0 : 60,
        maxHeight: MediaQuery.of(context).size.height / 2,
        parallaxEnabled: true,
        parallaxOffset: 0.4,
        header: Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          color: Color(0xFF898989).withOpacity(0.0),
          child: Center(
              child: Text('Last responses'.toUpperCase(),
                  style: TextStyle(
                    color: Color(0xFF898989),
                    fontWeight: FontWeight.w600,
                  ))),
        ),
        panel: Container(
          margin: const EdgeInsets.only(top: 60.0),
          child: Center(
            child: StreamBuilder<QuerySnapshot>(
                stream: repository.getStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return LinearProgressIndicator();
                  return _buildList(context, snapshot.data.documents);
                }),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    'Is this the end?',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF898989),
                      fontSize: 24,
                    ),
                  )),
              !toRender
                  ? Container()
                  : selectedValue != null
                      ? NeumorphicPie(
                          dataMap: <String, double>{'yes': yes, 'no': no},
                          selectedValue: selectedValue,
                        )
                      : _TextField(
                          placeholder: "Your comment",
                          onChanged: (val) {
                            comment = val;
                          },
                        ),
              !toRender
                  ? Container()
                  : selectedValue != null
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            NeumorphicButton(
                                margin: EdgeInsets.only(top: 20, right: 10),
                                onClick: () {
                                  _addResponse(true);
                                },
                                style: NeumorphicStyle(
                                    shape: NeumorphicShape.flat),
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(8)),
                                padding: const EdgeInsets.all(12.0),
                                child: Text("Yes, it is",
                                    style: TextStyle(
                                        color: Color(0xFFDC5C5C),
                                        fontWeight: FontWeight.w600))),
                            NeumorphicButton(
                                margin: EdgeInsets.only(top: 20, left: 10),
                                onClick: () {
                                  _addResponse(false);
                                },
                                style: NeumorphicStyle(
                                  // color: Color(0xFFDC5C5C),
                                  shape: NeumorphicShape.flat,
                                ),
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(8)),
                                padding: const EdgeInsets.all(12.0),
                                child: Text("No, it's not",
                                    style: TextStyle(
                                        color: Color(0xFF5AB359),
                                        fontWeight: FontWeight.w600))),
                          ],
                        ),
            ],
          ),
        ),
      ),
    );
  }

  void _addResponse(bool value) async {
    final id = await _getUniqueId();
    Response val = Response(id, value, comment);
    repository.addResponse(val);
    setState(() {
      comment = '';
    });
  }

  Future<String> _getUniqueId() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      return build.androidId;
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      return data.identifierForVendor;
    }
    return deviceInfoPlugin.toString();
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 0.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final res = Response.fromSnapshot(snapshot);
    if (res == null || res.comment == null) {
      return Container();
    }
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: InkWell(
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Text(res.comment == null ? "" : res.comment,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w500))),
              _getResponseIcon(res.value),
            ],
          ),
          highlightColor: Colors.green,
          splashColor: Colors.blue,
        ));
  }

  Widget _getResponseIcon(bool value) {
    if (value) {
      return IconButton(
        icon: Icon(Icons.pets),
        onPressed: () {},
      );
    } else {
      return IconButton(
        icon: Icon(Icons.pets),
        onPressed: () {},
      );
    }
  }
}

class _TextField extends StatefulWidget {
  final String placeholder;

  final ValueChanged<String> onChanged;

  _TextField({@required this.placeholder, this.onChanged});

  @override
  __TextFieldState createState() => __TextFieldState();
}

class __TextFieldState extends State<_TextField> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Neumorphic(
          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          boxShape: NeumorphicBoxShape.stadium(),
          style: NeumorphicStyle(
              depth: NeumorphicTheme.embossDepth(context) / 3.0),
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          child: TextField(
            onChanged: this.widget.onChanged,
            controller: _controller,
            decoration:
                InputDecoration.collapsed(hintText: this.widget.placeholder),
          ),
        )
      ],
    );
  }
}
