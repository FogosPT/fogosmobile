import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:redux/redux.dart';

class FireRisk extends StatelessWidget {
  final TextStyle _body = TextStyle(color: Colors.white, fontSize: 20);

  List<FireRiskStruct> _riskList;
  
  List<FireRiskStruct> generateStruct(BuildContext context) {
    return [
      FireRiskStruct(FogosLocalizations.of(context).textRiskReduced, Color(0xff6ABF59)),
      FireRiskStruct(FogosLocalizations.of(context).textRiskModerate, Color(0xffFFB202)),
      FireRiskStruct(FogosLocalizations.of(context).textRiskHigh, Color(0xffFF6E02)),
      FireRiskStruct(FogosLocalizations.of(context).textRiskVeryHigh, Color(0xffB81E1F)),
      FireRiskStruct(FogosLocalizations.of(context).textMaximumRisk, Color(0xff711313)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_riskList == null) {
      _riskList = generateStruct(context);
    }
    
    return StoreConnector<AppState, String>(
      converter: (Store<AppState> store) => store.state.fireRisk,
      builder: (BuildContext context, String stats) {
        if (stats == null) {
          return Center(child: CircularProgressIndicator());
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              for (var risk in _riskList) _buildRisk(risk, stats),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRisk(FireRiskStruct fireRisk, String currentRisk) {
    return Expanded(
      flex: currentRisk == fireRisk.risk ? 20 : 1,
      child: Container(
        height: 80,
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: fireRisk.color),
        child: Center(
          child: Text(
            currentRisk == fireRisk.risk ? currentRisk.toUpperCase() : "",
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
