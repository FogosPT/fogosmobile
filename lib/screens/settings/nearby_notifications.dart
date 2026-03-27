import 'package:flutter/material.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/services/nearby_notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NearbyNotifications extends StatefulWidget {
  @override
  _NearbyNotificationsState createState() => _NearbyNotificationsState();
}

class _NearbyNotificationsState extends State<NearbyNotifications> {
  bool _enabled = false;
  int _radiusKm = NearbyPrefs.defaultRadiusKm;
  String _filter = 'fires';
  bool _loading = true;
  bool _locationDenied = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _enabled = prefs.getBool(NearbyPrefs.nearbyEnabled) ?? false;
      _radiusKm =
          prefs.getInt(NearbyPrefs.nearbyRadiusKm) ?? NearbyPrefs.defaultRadiusKm;
      _filter = prefs.getString(NearbyPrefs.nearbyFilter) ?? 'fires';
      _loading = false;
    });
  }

  Future<void> _toggleEnabled(bool value) async {
    if (value) {
      var status = await Permission.locationWhenInUse.request();
      if (!status.isGranted) {
        setState(() => _locationDenied = true);
        return;
      }
      setState(() => _locationDenied = false);
    }

    setState(() => _enabled = value);
    await NearbyNotificationService.setEnabled(value);
  }

  Future<void> _setRadius(int km) async {
    setState(() => _radiusKm = km);
    await NearbyNotificationService.setRadius(km);
  }

  Future<void> _setFilter(String value) async {
    setState(() => _filter = value);
    await NearbyNotificationService.setFilter(
      value == 'fires' ? NearbyFilter.firesOnly : NearbyFilter.allIncidents,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = FogosLocalizations.of(context);

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Privacy notice
        Card(
          color: Color(0xffDEFFFC),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.shield, color: Colors.green.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.textNearbyPrivacyNotice,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.green.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Enable toggle
        SwitchListTile(
          title: Text(l10n.textNearbyNotifications),
          subtitle: Text(l10n.textNearbyNotificationsSubtitle),
          value: _enabled,
          onChanged: _toggleEnabled,
        ),

        if (_locationDenied)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              l10n.textNearbyLocationPermissionRequired,
              style: TextStyle(color: Color(0xffAD1F1F), fontSize: 13),
            ),
          ),

        // Radius selector
        if (_enabled) ...[
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              l10n.textNearbyAlertRadius,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              l10n.textNearbyRadiusDescription(_radiusKm),
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: NearbyPrefs.radiusOptions.map((km) {
                final selected = km == _radiusKm;
                return ChoiceChip(
                  label: Text('$km km'),
                  selected: selected,
                  onSelected: (_) => _setRadius(km),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),

          // Incident type filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              l10n.textNearbyIncidentType,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          RadioListTile<String>(
            title: Text(l10n.textNearbyFiresOnly),
            subtitle: Text(l10n.textNearbyFiresOnlySubtitle),
            value: 'fires',
            groupValue: _filter,
            onChanged: (value) => _setFilter(value!),
          ),
          RadioListTile<String>(
            title: Text(l10n.textNearbyAllIncidents),
            subtitle: Text(l10n.textNearbyAllIncidentsSubtitle),
            value: 'all',
            groupValue: _filter,
            onChanged: (value) => _setFilter(value!),
          ),

          const SizedBox(height: 24),

          // Visual indicator
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffE76700).withValues(alpha: 0.1),
                border: Border.all(
                  color: Color(0xffE76700).withValues(alpha: 0.4),
                  width: 2,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person_pin_circle,
                        size: 32, color: Color(0xffE76700)),
                    const SizedBox(height: 4),
                    Text(
                      '$_radiusKm km',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffE76700),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
