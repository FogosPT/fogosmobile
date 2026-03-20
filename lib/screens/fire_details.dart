import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/screens/components/details_history.dart';
import 'package:fogosmobile/screens/components/fireRisk.dart';
import 'package:fogosmobile/screens/components/fire_details/weather_card.dart';
import 'package:fogosmobile/screens/components/meansStatistics.dart';
import 'package:fogosmobile/screens/utils/widget_utils.dart';
import 'package:fogosmobile/screens/assets/images.dart';
import 'package:redux/redux.dart';
import 'package:fogosmobile/screens/components/fire_gradient_app_bar.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/actions/fires_actions.dart';

class FireDetailsPage extends StatelessWidget {
  final TextStyle _header = TextStyle(
    color: Color(0xffff512f),
    fontSize: 20,
  );

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      onDispose: (Store<AppState> store) {
        store.dispatch(ClearFireMeansAction());
        store.dispatch(ClearFireRiskAction());
        store.dispatch(ClearFireDetailsAction());
      },
      converter: (Store<AppState> store) => store.state,
      builder: (BuildContext context, AppState state) {
        Fire? fire = state.selectedFire;

        if (fire == null) {
          return Scaffold(
            appBar: FireGradientAppBar(
              title: Text(
                "",
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: Container(
              child: CircularProgressIndicator(),
            ),
          );
        }

        String _title = fire.town;

        if (fire.town != fire.local) {
          _title = '$_title, ${fire.local}';
        }

        return Scaffold(
          appBar: FireGradientAppBar(
            title: Text(
              _title,
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Container(
            child: ListView(
              children: <Widget>[
                // Fire info summary
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Location
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0, top: 2.0),
                            child: Icon(Icons.map, color: getFireColor(fire)),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(fire.district, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                                Text(fire.city, style: TextStyle(fontSize: 15.0)),
                                Text(fire.town, style: TextStyle(fontSize: 15.0)),
                                if (fire.town != fire.local)
                                  Text(fire.local, style: TextStyle(fontSize: 15.0, color: Colors.grey[700])),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      // Status
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: SvgPicture.asset(
                              getCorrectStatusImage(fire.statusCode, fire.important),
                              width: 24.0, height: 24.0,
                              color: getFireColor(fire),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${FogosLocalizations.of(context).textStatus}: ${FogosLocalizations.of(context).textFireStatus(fire.status)}',
                              style: TextStyle(fontSize: 15.0),
                            ),
                          ),
                        ],
                      ),
                      // Nature
                      if (fire.nature.isNotEmpty) ...[
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Icon(Icons.nature, color: getFireColor(fire)),
                            ),
                            Expanded(
                              child: Text(fire.nature, style: TextStyle(fontSize: 15.0)),
                            ),
                          ],
                        ),
                      ],
                      SizedBox(height: 12),
                      // Date/time
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Icon(Icons.access_time, color: getFireColor(fire)),
                          ),
                          Text('${fire.date} ${fire.time}', style: TextStyle(fontSize: 15.0)),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(),
                ListTile(title: Text(FogosLocalizations.of(context).textResources.toUpperCase(), style: _header)),
                SizedBox(height: 15),
                MeansStatistics(),
                SizedBox(height: 25),
                ListTile(title: Text(FogosLocalizations.of(context).textStatus.toUpperCase(), style: _header)),
                SizedBox(height: 15),
                DetailsHistoryStats(),
                SizedBox(height: 25),
                ListTile(title: Text(FogosLocalizations.of(context).textRiskOfFire.toUpperCase(), style: _header)),
                SizedBox(height: 15),
                FireRisk(),
                SizedBox(height: 25),
                if (fire.weather != null) ...[
                  ListTile(title: Text('TEMPO', style: _header)),
                  SizedBox(height: 15),
                  WeatherCard(weather: fire.weather!),
                  SizedBox(height: 25),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
