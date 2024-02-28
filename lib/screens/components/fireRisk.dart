import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:redux/redux.dart';

class FireRisk extends StatelessWidget {
  final TextStyle _body = TextStyle(color: Colors.white, fontSize: 20);

  List<FireRiskStruct> _riskList = [
    FireRiskStruct('Reduzido', Color(0xff6ABF59)),
    FireRiskStruct('Moderado', Color(0xffFFB202)),
    FireRiskStruct('Elevado', Color(0xffFF6E02)),
    FireRiskStruct('Muito Elevado', Color(0xffB81E1F)),
    FireRiskStruct('Máximo ', Color(0xff711313)),
  ];

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (Store<AppState> store) => store.state,
      onInit: (Store<AppState> store) {
        store.dispatch(LoadFireRiskAction(store.state.selectedFire?.id));
      },
      builder: (BuildContext context, AppState state) {
        String? stats = state.fireRisk;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              for (var risk in _riskList) _buildRisk(risk, stats, context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRisk(FireRiskStruct fireRisk, String? currentRisk, context) {
    final Map riskTranslations = {
      "Reduzido": FogosLocalizations.of(context).textRiskReduced,
      "Moderado": FogosLocalizations.of(context).textRiskModerate,
      "Elevado": FogosLocalizations.of(context).textRiskHigh,
      "Muito Elevado": FogosLocalizations.of(context).textRiskVeryHigh,
      "Máximo": FogosLocalizations.of(context).textMaximumRisk,
    };

    return Expanded(
      flex: currentRisk == fireRisk.risk ? 20 : 1,
      child: Container(
        height: 80,
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: fireRisk.color),
        child: Center(
          child: Text(
            currentRisk == fireRisk.risk
                ? riskTranslations[currentRisk].toUpperCase()
                : "",
            style: _body,
          ),
        ),
      ),
    );
  }
}

class FireRiskStruct {
  final String risk;
  final Color color;

  FireRiskStruct(this.risk, this.color);
}
