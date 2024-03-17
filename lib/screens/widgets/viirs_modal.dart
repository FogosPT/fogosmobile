import 'package:flutter/material.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/models/viirs.dart';
import 'package:fogosmobile/screens/utils/date_utils.dart';

class ViirsModal extends StatelessWidget {
  final Viirs viirs;

  const ViirsModal({Key? key, required this.viirs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "${FogosLocalizations.of(context).textDate}: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: FogosDateUtils.getDate(viirs.acqDate),
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "${FogosLocalizations.of(context).textBrightTi4}: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: viirs.brightTi4,
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "${FogosLocalizations.of(context).textBrightTi5}: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: viirs.brightTi5,
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "${FogosLocalizations.of(context).textFrp}: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: viirs.frp,
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "${FogosLocalizations.of(context).textConfidence}: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: getConfidence(context, viirs.confidence),
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getConfidence(BuildContext context, String confidence) {
    if (confidence == 'nominal') {
      return FogosLocalizations.of(context).textNominalConfidence;
    } else if (confidence == 'low') {
      return FogosLocalizations.of(context).textLowConfidence;
    } else if (confidence == 'high') {
      return FogosLocalizations.of(context).textHighConfidence;
    }
    return confidence;
  }
}
