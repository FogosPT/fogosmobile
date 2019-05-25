import 'package:flutter/material.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/screens/components/fire_gradient_app_bar.dart';
import 'package:fogosmobile/screens/settings/notifications.dart';
import 'package:fogosmobile/screens/settings/fire_notifications.dart';
import 'package:fogosmobile/screens/settings/other_notifications.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: new FireGradientAppBar(
          title: new Text(
            FogosLocalizations.of(context).textNotifications,
            style: new TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.map)),
              Tab(icon: Icon(Icons.notifications)),
              Tab(text: FogosLocalizations.of(context).textOther),
            ],
          ),
        ),
        body: TabBarView(
          children: [Notifications(), FireNotifications(), OtherNotifications()],
        ),
      ),
    );
  }
}
