import 'package:flutter/material.dart';
import 'package:fogosmobile/models/modis.dart';

import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/screens/utils/date_utils.dart';

class ModisModal extends StatelessWidget {
  final Modis modis;

  const ModisModal({Key key, this.modis}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "${FogosLocalizations.of(context).textDate}: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  TextSpan(
                      text: FogosDateUtils.getDate(modis.acqDate),
                      style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "${FogosLocalizations.of(context).textBrightT31}: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  TextSpan(
                      text: modis.brightT31,
                      style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text:
                      "${FogosLocalizations.of(context).textBrightness}: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  TextSpan(
                      text: modis.brightness,
                      style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: "${FogosLocalizations.of(context).textFrp}: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  TextSpan(
                      text: modis.frp, style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text:
                      "${FogosLocalizations.of(context).textConfidence}: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  TextSpan(
                      text: "${modis.confidence}%",
                      style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
