import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MapboxCopyright extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0.0,
      right: 0.0,
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: Colors.grey[200],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: () => _launchUrl('https://www.mapbox.com/about/maps/',),
                  child: Text('© Mapbox',
                    style: TextStyle(decoration: TextDecoration.underline, fontSize: 12.0),),
                ),
                InkWell(
                  onTap: () => _launchUrl('http://www.openstreetmap.org/copyright'),
                  child: Text('© OpenStreetMap',
                      style: TextStyle(decoration: TextDecoration.underline, fontSize: 12.0)),
                ),
                InkWell(
                  onTap: () => _launchUrl('https://www.mapbox.com/map-feedback/'),
                  child: Text('Improve this map',
                      style: TextStyle(decoration: TextDecoration.underline, fontSize: 12.0)),
                ),
                SizedBox(
                  width: 12.0,
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
        ),
      ),
    );
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir: $url';
    }
  }
}
