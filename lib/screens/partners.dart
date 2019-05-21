import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:flutter/material.dart';
import 'package:fogosmobile/utils/uri_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/fire_gradient_app_bar.dart';

class Partners extends StatefulWidget {
  @override
  _PartnersState createState() => _PartnersState();
}

class _PartnersState extends State<Partners> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: FireGradientAppBar(
          iconTheme: new IconThemeData(color: Colors.white),
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
