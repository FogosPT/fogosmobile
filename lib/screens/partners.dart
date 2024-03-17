import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:flutter/material.dart';
import 'package:fogosmobile/utils/uri_utils.dart';
import 'package:fogosmobile/screens/components/fire_gradient_app_bar.dart';

class Partners extends StatelessWidget {
  const Partners();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FireGradientAppBar(
        title: Text(
          FogosLocalizations.of(context).textPartners,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(15.0),
          children: [
            TextButton(
              child: Image.asset("assets/partners/mapbox.png"),
              onPressed: () {
                launchURL('https://www.mapbox.com/');
              },
            ),
            Padding(padding: EdgeInsets.only(bottom: 15.0)),
            TextButton(
              child: Image.asset("assets/partners/officelan.png"),
              onPressed: () {
                launchURL('https://officelan.pt/');
              },
            ),
            Padding(padding: EdgeInsets.only(bottom: 15.0)),
            TextButton(
              child: Image.asset("assets/partners/fll.png"),
              onPressed: () {
                launchURL('https://fundacaolapadolobo.pt/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
