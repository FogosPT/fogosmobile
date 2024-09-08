import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fogospt/features/map/application/fires_map_configuration.dart';
import 'package:fogospt/features/map/application/fires_map_markers.dart';
import 'package:fogospt/features/map/application/map_latest_fires/map_latest_fires_cubit.dart';
import 'package:warnings/warnings.dart';

class MapPageView extends StatelessWidget {
  const MapPageView({
    super.key,
    required this.mapMarkers,
  });

  final FiresMapMarkers mapMarkers;

  @override
  Widget build(BuildContext context) {
    final state = context.read<MapLatestFiresCubit>().state;

    return Stack(
      children: [
        if (state.isLoading) const Center(child: CircularProgressIndicator()),
        FlutterMap(
          options: FiresMapConfiguration.getMapOptions(),
          children: [
            FiresMapConfiguration.getTileLayer(),
            MarkerLayer(
              markers: mapMarkers.processMarkers(),
            )
          ],
        ),
      ],
    );
  }
}
