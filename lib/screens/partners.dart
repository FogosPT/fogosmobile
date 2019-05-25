import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:flutter/material.dart';
import 'package:fogosmobile/utils/uri_utils.dart';
import 'package:fogosmobile/screens/components/fire_gradient_app_bar.dart';

class Partners extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: FireGradientAppBar(
          title: new Text(
            FogosLocalizations.of(context).textPartners,
            style: new TextStyle(color: Colors.white),
          ),
        ),
        body: new Center(
          child: new ListView(
            padding: EdgeInsets.all(15.0),
            children: [
              new FlatButton(
                  child: Image.asset("assets/partners/mapbox.png"),
                  onPressed: () {
                    launchURL('https://www.mapbox.com/');
                  }),
              Padding(
                padding: EdgeInsets.only(
                  bottom: 15.0,
                ),
              ),
              new FlatButton(
                  child: Image.asset("assets/partners/brpx.png"),
                  onPressed: () {
                    launchURL('https://brpx.com/');
                  })
            ],
          ),
        ));
  }
}
