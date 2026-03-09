import 'package:flutter/material.dart';
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
  String _filter = 'fires'; // 'fires' or 'all'
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
      // Ask for location permission first
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
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Privacy notice
        Card(
          color: Colors.green.shade50,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.shield, color: Colors.green.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'A sua localização nunca é enviada para os nossos servidores. '
                    'O cálculo de proximidade é feito exclusivamente no seu dispositivo.',
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
          title: const Text('Notificações por proximidade'),
          subtitle: const Text(
              'Receba alertas quando um novo incêndio ocorrer perto de si'),
          value: _enabled,
          onChanged: _toggleEnabled,
        ),

        if (_locationDenied)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'É necessário permitir o acesso à localização para utilizar esta funcionalidade.',
              style: TextStyle(color: Colors.red.shade700, fontSize: 13),
            ),
          ),

        // Radius selector
        if (_enabled) ...[
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Raio de alerta',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Será notificado quando um novo incêndio ocorrer dentro de $_radiusKm km da sua localização.',
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
              'Tipo de ocorrências',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          RadioListTile<String>(
            title: const Text('Apenas incêndios'),
            subtitle: const Text('Incêndios rurais, urbanos e de transporte'),
            value: 'fires',
            groupValue: _filter,
            onChanged: (value) => _setFilter(value!),
          ),
          RadioListTile<String>(
            title: const Text('Todos os incidentes'),
            subtitle: const Text('Incêndios, acidentes e outras ocorrências'),
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
                color: Colors.orange.withValues(alpha: 0.1),
                border: Border.all(
                  color: Colors.orange.withValues(alpha: 0.4),
                  width: 2,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person_pin_circle,
                        size: 32, color: Colors.orange),
                    const SizedBox(height: 4),
                    Text(
                      '$_radiusKm km',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
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
