import 'package:flutter/material.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/models/statistics.dart';
import 'package:fogosmobile/screens/components/fire_gradient_app_bar.dart';
import 'package:fogosmobile/screens/components/todayStatistics.dart';
import 'package:fogosmobile/screens/components/weekStatistics.dart';
import 'package:fogosmobile/screens/components/lastHoursStatistics.dart';
import 'package:fogosmobile/screens/components/lastNightStatistics.dart';
import 'package:fogosmobile/screens/components/nowStatistics.dart';
import 'package:fogosmobile/screens/components/yesterdayStatistics.dart';

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
      appBar: new FireGradientAppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        title: new Text(
          FogosLocalizations.of(context).textStatistics,
          style: new TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(title: Text("AGORA", style: _header)),
          SizedBox(height: 10),
          NowStatistics(),
          SizedBox(height: 25),
          LastHoursStatistics(),
          SizedBox(height: 15),
          Divider(color: Color(0xffff512f)),
          SizedBox(height: 15),
          ListTile(title: Text("HOJE", style: _header)),
          TodayStatistics(),
          SizedBox(height: 15),
          Divider(color: Color(0xffff512f)),
          SizedBox(height: 15),
          ListTile(title: Text("ONTEM", style: _header)),
          YesterdayStatistics(),
          SizedBox(height: 15),
          Divider(color: Color(0xffff512f)),
          SizedBox(height: 15),
          ListTile(title: Text("ÚLTIMA NOITE", style: _header)),
          LastNightStatistics(),
          SizedBox(height: 15),
          Divider(color: Color(0xffff512f)),
          SizedBox(height: 15),
          ListTile(title: Text("ÚLTIMOS DIAS", style: _header)),
          WeekStatistics(),
          SizedBox(height: 25),
        ],
      ),
    );
  }
}
