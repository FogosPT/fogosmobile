import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/constants/ipma_layers.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/utils/uri_utils.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:redux/redux.dart';

class MapboxCopyright extends StatelessWidget {

  const MapboxCopyright({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Set<String>>(
      distinct: true,
      converter: (Store<AppState> store) => store.state.activeIpmaLayers,
      builder: (context, activeIpma) {
        final hasArome =
            activeIpma.any((k) => k != ipmaFrpGroup.key);
        final hasFrp = activeIpma.contains(ipmaFrpGroup.key);

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
                    _createCopyrightOption(
                        '© Mapbox', 'https://www.mapbox.com/about/maps/'),
                    _createCopyrightOption('© OpenStreetMap',
                        'http://www.openstreetmap.org/copyright'),
                    _createCopyrightOption(
                        FogosLocalizations.of(context).textMapboxImprove,
                        'https://www.mapbox.com/map-feedback/'),
                    if (hasArome)
                      _createCopyrightOption(
                          'Previsão © IPMA (modelo AROME)',
                          'https://www.ipma.pt'),
                    if (hasFrp)
                      _createCopyrightOption(
                          'FRP © LSA-SAF / IPMA',
                          'https://lsa-saf.eumetsat.int'),
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
      },
    );
  }

  InkWell _createCopyrightOption(String title, String url) {
    return InkWell(
      onTap: () => launchURL(url),
      child: Text(title,
          style:
              TextStyle(decoration: TextDecoration.underline, fontSize: 12.0)),
    );
  }
}
