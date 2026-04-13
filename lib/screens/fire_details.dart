import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/models/icnf.dart';
import 'package:fogosmobile/screens/components/details_history.dart';
import 'package:fogosmobile/screens/components/fireRisk.dart';
import 'package:fogosmobile/screens/components/fire_details/weather_card.dart';
import 'package:fogosmobile/screens/components/meansStatistics.dart';
import 'package:fogosmobile/screens/incident_camera/incident_camera_screen.dart';
import 'package:fogosmobile/screens/utils/widget_utils.dart';
import 'package:fogosmobile/screens/assets/images.dart';
import 'package:fogosmobile/screens/widgets/kml_map_widget.dart';
import 'package:redux/redux.dart';
import 'package:fogosmobile/screens/components/fire_gradient_app_bar.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/actions/fires_actions.dart';

class FireDetailsPage extends StatelessWidget {
  final TextStyle _header = TextStyle(
    color: Color(0xffF25C54),
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
            actions: [
              IconButton(
                icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => IncidentCameraScreen(fire: fire),
                    ),
                  );
                },
              ),
            ],
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
                if (fire.kml != null) ...[
                  ListTile(title: Text('ÁREA ARDIDA', style: _header)),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: KmlMapWidget(kmlContent: fire.kml!),
                  ),
                  SizedBox(height: 25),
                ],
                if (fire.kmlVost != null) ...[
                  ListTile(title: Text('ÁREA DE INTERESSE', style: _header)),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: KmlMapWidget(kmlContent: fire.kmlVost!),
                  ),
                  SizedBox(height: 25),
                ],
                if (fire.icnf != null) ...[
                  ListTile(title: Text('ICNF', style: _header)),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _IcnfDetailCard(icnf: fire.icnf!),
                  ),
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

class _IcnfDetailCard extends StatelessWidget {
  final Icnf icnf;

  const _IcnfDetailCard({required this.icnf});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffF25C54).withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icnf.incendio == true)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xffF25C54),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Incêndio confirmado',
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          if (icnf.burnArea != null) ...[
            const Text('Área Ardida', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 12),
            Row(
              children: [
                _AreaItem(label: 'Povoamento', value: icnf.burnArea!.povoamento),
                _AreaItem(label: 'Mato', value: icnf.burnArea!.mato),
                _AreaItem(label: 'Agrícola', value: icnf.burnArea!.agricola),
                _AreaItem(label: 'Total', value: icnf.burnArea!.total, highlight: true),
              ],
            ),
          ],
          if (icnf.altitude != null || icnf.fonteAlerta != null) ...[
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            if (icnf.altitude != null)
              _InfoRow(icon: Icons.terrain, label: 'Altitude', value: '${icnf.altitude!.toStringAsFixed(0)} m'),
            if (icnf.fonteAlerta != null)
              _InfoRow(icon: Icons.notifications_outlined, label: 'Fonte de alerta', value: icnf.fonteAlerta!),
          ],
        ],
      ),
    );
  }
}

class _AreaItem extends StatelessWidget {
  final String label;
  final double value;
  final bool highlight;

  const _AreaItem({required this.label, required this.value, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '${value.toStringAsFixed(0)} ha',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: highlight ? const Color(0xffF25C54) : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
