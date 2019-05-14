import 'dart:convert';
import 'dart:convert' show utf8;
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fogosmobile/constants/endpoints.dart';

typedef SetPreferenceCallBack = Function(String key, int value);

class Warnings extends StatefulWidget {
  @override
  _WarningsState createState() => _WarningsState();
}

class _WarningsState extends State<Warnings> {
  List warnings = [];
  TextEditingController controller = new TextEditingController();
  String filter;

  @override
  initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }

  getLocations() async {
    String url = endpoints['getWarnings'];
    final response = await http.get(url);
    final data = json.decode(utf8.decode(response.bodyBytes));
    return data['data'];
  }

  @override
  Widget build(BuildContext context) {
    if (this.warnings.length == 0) {
      getLocations().then((locs) {
        setState(() {
          this.warnings = locs;
        });
      });

      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.redAccent,
                iconTheme: new IconThemeData(color: Colors.white),
                title: new Text(
                  FogosLocalizations.of(context).textWarnings,
                  style: new TextStyle(color: Colors.white),
                ),
              ),
              body: 

            new Column(
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.only(top: 20.0),
                ),
                new Expanded(
                  child: new ListView.builder(
                    itemCount: this.warnings.length,
                    itemBuilder: (BuildContext context, int index) {
                      final _warning = this.warnings[index];
                      return ListTile(
                        leading: Text(_warning['label'], style: TextStyle(color: Colors.redAccent),),
                        title: Text(_warning['text']),
                        );
                    },
                  ),
                ),
              ],
            ),
            ),
        );
  }
}
