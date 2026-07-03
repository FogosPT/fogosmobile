import 'package:flutter/material.dart';
import 'package:fogosmobile/models/plane.dart';

class PlaneModal extends StatelessWidget {
  final Plane plane;

  const PlaneModal({Key? key, required this.plane}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final last = plane.lastPosition;
    final now = DateTime.now().toUtc();
    final lastSeen = last?.created ?? last?.sampledAt;
    final minsAgo =
        lastSeen == null ? null : now.difference(lastSeen.toUtc()).inMinutes;

    final title = [
      if (plane.name != null && plane.name!.isNotEmpty) plane.name!,
      if (plane.registration != null && plane.registration!.isNotEmpty)
        '(${plane.registration!})',
    ].join(' ');

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            if (title.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            if (plane.aircraftType != null && plane.aircraftType!.isNotEmpty)
              _Row('Tipo', plane.aircraftType!),
            if (plane.operator_ != null && plane.operator_!.isNotEmpty)
              _Row('Operador', plane.operator_!),
            if (plane.base != null && plane.base!.isNotEmpty)
              _Row('Base', plane.base!),
            _Row('ICAO', plane.icao),
            if (last != null) ...[
              const SizedBox(height: 8),
              const Divider(),
              if (last.altitude != null)
                _Row('Altitude', '${last.altitude} ft'),
              if (last.groundSpeed != null)
                _Row('Velocidade',
                    '${last.groundSpeed} kt (${(last.groundSpeed! * 1.852).round()} km/h)'),
              if (last.track != null) _Row('Rumo', '${last.track}°'),
              if (last.onGround) _Row('Estado', 'No solo'),
              if (minsAgo != null)
                _Row(
                  'Última posição',
                  minsAgo <= 1 ? 'agora mesmo' : 'há $minsAgo min',
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;

  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
