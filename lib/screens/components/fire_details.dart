import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/actions/preferences_actions.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/models/icnf.dart';
import 'package:fogosmobile/constants/routes.dart';
import 'package:fogosmobile/screens/utils/widget_utils.dart';
import 'package:fogosmobile/screens/assets/images.dart';
import 'package:fogosmobile/screens/components/fire_details/important_fire_extra.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:redux/redux.dart';
import 'package:share_plus/share_plus.dart';

typedef SetPreferenceCallBack = Function(String key, int value);

class FireDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, VoidCallback>(
      converter: (Store<AppState> store) {
        return () {
          store.dispatch(ClearFireAction());
        };
      },
      builder: (BuildContext context, VoidCallback clearFireAction) {
        return StoreConnector<AppState, AppState>(
          converter: (Store<AppState> store) => store.state,
          builder: (BuildContext context, AppState state) {
            Fire? fire = state.selectedFire;
            if (fire == null) {
              if (state.errors != null && state.errors.contains('fire')) {
                return Center(child: Text(FogosLocalizations.of(context).textProblemLoadingData));
              }

              return ModalProgressHUD(
                opacity: 0.75,
                color: Colors.black,
                inAsyncCall: true,
                child: Container(),
              );
            }

            return StoreConnector<AppState, SetPreferenceCallBack>(
              converter: (Store<AppState> store) {
                return (String fireId, int value) {
                  store.dispatch(SetFireNotificationAction(fireId, value));
                };
              },
              builder: (BuildContext context,
                  SetPreferenceCallBack setPreferenceAction) {
                bool isFireSubscribed = false;
                final subscribedFires = state.preferences['subscribedFires'] ?? [];
                if (subscribedFires.length > 0) {
                  isFireSubscribed = subscribedFires.any((fs) => fs.id == fire.id);
                }
                return SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.share),
                                      onPressed: () {
                                        Share.share(
                                            FogosLocalizations.of(context)
                                                .textShare(fire.city, fire.id));
                                      },
                                    ),
                                    SizedBox(width: 8),
                                    state.isLoading
                                        ? IconButton(
                                            icon: CircularProgressIndicator(),
                                            onPressed: () {},
                                          )
                                        : IconButton(
                                            icon: Icon(isFireSubscribed
                                                ? Icons.notifications_active
                                                : Icons.notifications_none),
                                            onPressed: () {
                                              setPreferenceAction(fire.id,
                                                  isFireSubscribed ? 0 : 1);
                                            },
                                          ),
                                    SizedBox(width: 8),
                                    IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        clearFireAction();
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 16.0),
                                      child: Icon(
                                        Icons.map,
                                        color: getFireColor(fire),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          Text(
                                            fire.district,
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                          Text(
                                            fire.city,
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                          Text(
                                            fire.town,
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                          Text(
                                            fire.local,
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                          if (fire.detailLocation != null)
                                            Text(
                                              fire.detailLocation!,
                                              style: TextStyle(fontSize: 16.0),
                                            ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20.0),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 16.0),
                                      child: SvgPicture.asset(
                                        getCorrectStatusImage(
                                          fire.statusCode,
                                          fire.important,
                                        ),
                                        width: 25.0,
                                        height: 25.0,
                                        color: getFireColor(fire),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          Text(
                                            '${FogosLocalizations.of(context).textStatus}: ${FogosLocalizations.of(context).textFireStatus(fire.status)}',
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20.0),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 16.0),
                                      child: Icon(
                                        Icons.nature,
                                        color: getFireColor(fire),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          Text(
                                            fire.nature ?? '',
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20.0),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 16.0),
                                      child: SvgPicture.asset(
                                        imgSvgFireman,
                                        width: 35.0,
                                        height: 35.0,
                                        color: getFireColor(fire),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          Text(
                                            '${FogosLocalizations.of(context).textHumanMeans}: ${fire.human}',
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                          Text(
                                            '${FogosLocalizations.of(context).textTerrainMeans}: ${fire.terrain}',
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                          Text(
                                            '${FogosLocalizations.of(context).textAerealMeans}: ${fire.aerial}',
                                            style: TextStyle(fontSize: 16.0),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20.0),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 16.0),
                                      child: Icon(
                                        Icons.access_time,
                                        color: getFireColor(fire),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          Text(
                                            '${fire.date} ${fire.time}',
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                 Padding(
                                  padding: EdgeInsets.only(top: 20.0),
                                ),
                                ImportantFireExtra(fire),
                                if (fire.weather != null) ...[
                                  Padding(
                                    padding: EdgeInsets.only(top: 20.0),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Color(0xffF25C54).withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.location_on, color: Color(0xffF25C54), size: 16),
                                            SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                fire.weather!.stationLocation,
                                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xffF25C54)),
                                              ),
                                            ),
                                            Text(
                                              (() {
                                                try {
                                                  final dt = DateTime.parse(fire.weather!.date);
                                                  return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
                                                } catch (_) {
                                                  return fire.weather!.date;
                                                }
                                              })(),
                                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(children: [
                                              Icon(Icons.thermostat, size: 16, color: Color(0xffF25C54)),
                                              SizedBox(width: 4),
                                              Text('${fire.weather!.temperatura.toStringAsFixed(1)}°C', style: TextStyle(fontSize: 13)),
                                            ]),
                                            Row(children: [
                                              Icon(Icons.water_drop, size: 16, color: Color(0xffF25C54)),
                                              SizedBox(width: 4),
                                              Text('${fire.weather!.humidade.toStringAsFixed(0)}%', style: TextStyle(fontSize: 13)),
                                            ]),
                                            Row(children: [
                                              Icon(Icons.air, size: 16, color: Color(0xffF25C54)),
                                              SizedBox(width: 4),
                                              Text('${fire.weather!.intensidadeVentoKM.toStringAsFixed(0)} km/h ${fire.weather!.direccVento}', style: TextStyle(fontSize: 13)),
                                            ]),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                if (fire.kml != null) ...[
                                  Padding(padding: EdgeInsets.only(top: 20.0)),
                                  _KmlBadge(label: 'Área Ardida (ICNF)'),
                                ],
                                if (fire.icnf != null) ...[
                                  Padding(padding: EdgeInsets.only(top: 20.0)),
                                  _IcnfCard(icnf: fire.icnf!),
                                ],
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    TextButton.icon(
                                        label: Text('MAIS INFORMAÇÕES'),
                                        icon: Icon(Icons.info),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushNamed(FIRE_DETAILS_ROUTE);
                                        }),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _IcnfCard extends StatelessWidget {
  final Icnf icnf;

  const _IcnfCard({required this.icnf});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffF25C54).withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_fire_department, color: Color(0xffF25C54), size: 16),
              const SizedBox(width: 6),
              Text(
                'Área ardida via ICNF',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffF25C54),
                ),
              ),
              const Spacer(),
              if (icnf.incendio == true)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xffF25C54),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Incêndio',
                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          if (icnf.burnArea != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                _BurnAreaItem(label: 'Povoamento', value: icnf.burnArea!.povoamento),
                _BurnAreaItem(label: 'Mato', value: icnf.burnArea!.mato),
                _BurnAreaItem(label: 'Agrícola', value: icnf.burnArea!.agricola),
                _BurnAreaItem(label: 'Total', value: icnf.burnArea!.total, highlight: true),
              ],
            ),
          ],
          if (icnf.altitude != null || icnf.fonteAlerta != null) ...[
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Row(
              children: [
                if (icnf.altitude != null) ...[
                  const Icon(Icons.terrain, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${icnf.altitude!.toStringAsFixed(0)} m',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
                if (icnf.altitude != null && icnf.fonteAlerta != null)
                  const SizedBox(width: 16),
                if (icnf.fonteAlerta != null) ...[
                  const Icon(Icons.notifications_outlined, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'Alerta: ${icnf.fonteAlerta}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _KmlBadge extends StatelessWidget {
  final String label;

  const _KmlBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xffF25C54).withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xffF25C54).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.map_outlined, size: 14, color: Color(0xffF25C54)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xffF25C54), fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _BurnAreaItem extends StatelessWidget {
  final String label;
  final double value;
  final bool highlight;

  const _BurnAreaItem({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '${value.toStringAsFixed(0)} ha',
            style: TextStyle(
              fontSize: 14,
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              color: highlight ? const Color(0xffF25C54) : Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
