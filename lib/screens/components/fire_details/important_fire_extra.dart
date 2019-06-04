import 'package:flutter/material.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/screens/utils/widget_utils.dart';

class ImportantFireExtra extends StatelessWidget {
  final Fire fire;

  ImportantFireExtra(this.fire);

  _getImportantFireExtraInfo() {
    List<Widget> extraInfo = [];

    if (fire.extra != null && fire.extra.isNotEmpty) {
      extraInfo.add(
        Text(
          fire.extra,
        ),
      );

      extraInfo.add(
        Padding(
          padding: EdgeInsets.only(bottom: 6.0),
        ),
      );
    }

    if (fire.cos != null && fire.cos.isNotEmpty) {
      extraInfo.add(
        Text(
          fire.cos,
        ),
      );

      extraInfo.add(
        Padding(
          padding: EdgeInsets.only(bottom: 6.0),
        ),
      );
    }

    if (fire.pco != null && fire.pco.isNotEmpty) {
      extraInfo.add(
        Text(
          fire.pco,
        ),
      );
    }

    return extraInfo;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> extraInfo = _getImportantFireExtraInfo();

    if (extraInfo.length == 0) {
      return Container();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Icon(
            Icons.add,
            color: getFireColor(fire),
          ),
        ),
        Expanded(
          child: Column(
            children: extraInfo,
          ),
        )
      ],
    );
  }
}
