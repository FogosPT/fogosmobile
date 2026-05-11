import 'package:flutter/material.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/screens/components/fire_gradient_app_bar.dart';
import 'package:fogosmobile/screens/settings/notifications.dart';
import 'package:fogosmobile/screens/settings/fire_notifications.dart';
import 'package:fogosmobile/screens/settings/nearby_notifications.dart';
import 'package:fogosmobile/screens/settings/other_notifications.dart';
import 'package:fogosmobile/screens/settings/photo_signature_settings.dart';
import 'package:fogosmobile/screens/settings/reset_notifications.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: FireGradientAppBar(
          title: Text(
            FogosLocalizations.of(context).textNotifications,
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.map)),
              Tab(icon: Icon(Icons.notifications)),
              Tab(icon: Icon(Icons.near_me)),
              Tab(text: FogosLocalizations.of(context).textOther),
              Tab(icon: Icon(Icons.photo_camera)),
              Tab(icon: Icon(Icons.settings)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Notifications(),
            FireNotifications(),
            NearbyNotifications(),
            OtherNotifications(),
            const PhotoSignatureSettings(),
            ResetNotifications(),
          ],
        ),
      ),
    );
  }
}
