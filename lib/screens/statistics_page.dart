import 'package:flutter/material.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/models/statistics.dart';
import 'package:fogosmobile/screens/components/todayStatistics.dart';
import 'package:fogosmobile/screens/components/weekStatistics.dart';

import 'components/lastHoursStatistics.dart';
import 'components/lastNightStatistics.dart';
import 'components/nowStatistics.dart';
import 'components/yesterdayStatistics.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  YesterdayStats yesterdayStats;
  TodayStats todayStats;

  final TextStyle _header = TextStyle(
    color: Color(0xffff512f),
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.redAccent,
        iconTheme: new IconThemeData(color: Colors.white),
        title: new Text(
          FogosLocalizations.of(context).textStatistics,
          style: new TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(title: Text("AGORA", style: _header)),
          Row(
            children: <Widget>[
              NowStatistics(),
            ],
          ),
          LastHoursStatistics(),
          ListTile(title: Text("HOJE", style: _header)),
          TodayStatistics(),
          ListTile(title: Text("ONTEM", style: _header)),
          YesterdayStatistics(),
          ListTile(title: Text("ÚLTIMA NOITE", style: _header)),
          LastNightStatistics(),
          ListTile(title: Text("ÚLTIMOS DIAS", style: _header)),
          WeekStatistics(),
        ],
      ),
    );
  }
}
