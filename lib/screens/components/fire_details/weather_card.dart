import 'package:flutter/material.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/models/weather.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;

  const WeatherCard({Key? key, required this.weather}) : super(key: key);

  String _formatTime(String date) {
    try {
      final dt = DateTime.parse(date);
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Station header
              Row(
                children: [
                  Icon(Icons.location_on, color: Color(0xffF25C54), size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          weather.stationLocation,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffF25C54),
                          ),
                        ),
                        if (weather.stationDistance != null)
                          Text(
                            FogosLocalizations.of(context).textKmFromIncident(weather.stationDistance!.toStringAsFixed(1)),
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                      ],
                    ),
                  ),
                  Icon(Icons.schedule, color: Colors.grey, size: 16),
                  SizedBox(width: 4),
                  Text(
                    _formatTime(weather.date),
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Weather grid
              Wrap(
                spacing: 16,
                runSpacing: 12,
                children: [
                  _weatherItem(Icons.thermostat, '${weather.temperatura.toStringAsFixed(1)}°C', 'Temperatura'),
                  _weatherItem(Icons.water_drop, '${weather.humidade.toStringAsFixed(1)}%', 'Humidade'),
                  _weatherItem(Icons.air, '${weather.intensidadeVentoKM.toStringAsFixed(1)} km/h ${weather.direccVento}', 'Vento'),
                  _weatherItem(Icons.umbrella, '${weather.precAcumulada.toStringAsFixed(1)} mm', 'Precipitação'),
                  _weatherItem(Icons.wb_sunny, '${weather.radiacao.toStringAsFixed(0)} W/m²', 'Radiação'),
                  _weatherItem(Icons.speed, '${weather.pressao.toStringAsFixed(1)} hPa', 'Pressão'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _weatherItem(IconData icon, String value, String label) {
    return SizedBox(
      width: 150,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Color(0xffF25C54), size: 20),
          SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
