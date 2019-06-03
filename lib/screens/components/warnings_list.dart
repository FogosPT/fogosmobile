import 'package:flutter/material.dart';
import 'package:fogosmobile/models/warning.dart';

class WarningsList extends StatelessWidget {
  final List warnings;

  WarningsList({this.warnings});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        new Padding(
          padding: new EdgeInsets.only(top: 10.0),
        ),
        new Expanded(
          child: new ListView.builder(
            itemCount: warnings.length,
            itemBuilder: (BuildContext context, int index) {
              Warning warning = warnings[index];
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.5), color: Color(0xfff45e29)
                      ),
                      child: Text(warning.timestamp, style: TextStyle(color: Colors.white), textAlign: TextAlign.left)
                    ),
                    _buildWarningBody(warning),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWarningBody(var warning) {
    if(warning.title != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
            child: Text(warning.title, style: TextStyle(color: Colors.redAccent, fontSize: 16)),
          ),
          Text(warning.description),
        ],
      );
    }
    return Container(
      padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
      child: Text(warning.description)
    );
  }
}
