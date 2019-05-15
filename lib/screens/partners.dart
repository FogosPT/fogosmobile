import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Partners extends StatefulWidget {
  @override
  _PartnersState createState() => _PartnersState();
}

class _PartnersState extends State<Partners> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
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
                    _launchUrl('https://www.mapbox.com/');
                  }),
              Padding(
                padding: EdgeInsets.only(
                  bottom: 15.0,
                ),
              ),
              new FlatButton(
                  child: Image.asset("assets/partners/brpx.png"),
                  onPressed: () {
                    _launchUrl('https://brpx.com/');
                  })
            ],
          ),
        ));
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir: $url';
    }
  }
}
