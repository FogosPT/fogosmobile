import 'package:flutter/material.dart';
import 'package:fogos_api/features/latest_warnings/domain/fire.dart';

class MapPageModalContent extends StatelessWidget {
  final Fire fire;
  const MapPageModalContent({
    super.key,
    required this.fire,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FireModalLocation(fire: fire),
        FireModalStatus(fire: fire),
        FireModalResources(fire: fire),
        FireModalUpdated(fire: fire),
      ],
    );
  }
}

class FireModalLocation extends StatelessWidget {
  final Fire fire;
  const FireModalLocation({
    super.key,
    required this.fire,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.map),
        Column(
          children: [
            Text(fire.district),
            Text(fire.concelho),
            Text(fire.freguesia),
            Text(fire.location),
          ],
        )
      ],
    );
  }
}

class FireModalStatus extends StatelessWidget {
  final Fire fire;
  const FireModalStatus({
    super.key,
    required this.fire,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Icon(Icons.fire_extinguisher), Text('Status: ${fire.status}')],
    );
  }
}

class FireModalResources extends StatelessWidget {
  final Fire fire;
  const FireModalResources({
    super.key,
    required this.fire,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.man_4),
        Column(
          children: [
            Text('Bombeiros: ${fire.man}'),
            Text('Veiculos: ${fire.terrain}'),
            Text('Meios Aereos: ${fire.aerial}'),
          ],
        )
      ],
    );
  }
}

class FireModalUpdated extends StatelessWidget {
  final Fire fire;
  const FireModalUpdated({
    super.key,
    required this.fire,
  });

  @override
  Widget build(BuildContext context) {
    final Duration secofire = Duration(seconds: fire.updated.sec);
    return Row(children: [
      Icon(Icons.update_outlined),
      Text(secofire.toString()),
    ]);
  }
}
