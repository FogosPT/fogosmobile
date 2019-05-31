import 'package:flutter/material.dart';

class WarningsList extends StatelessWidget {
  final List warnings;

  WarningsList({this.warnings});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        new Padding(
          padding: new EdgeInsets.only(top: 20.0),
        ),
        new Expanded(
          child: new ListView.builder(
            itemCount: warnings.length,
            itemBuilder: (BuildContext context, int index) {
              var warning = warnings[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: ListTile(
                  title: Text(
                    warning.title,
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  subtitle: Text(warning.description),
                  isThreeLine: false,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
