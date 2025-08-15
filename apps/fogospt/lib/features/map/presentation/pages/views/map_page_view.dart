import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fogos_api/features/latest_warnings/domain/fire.dart';
import 'package:fogospt/features/map/application/fires_map_configuration.dart';
import 'package:fogospt/features/map/application/fires_map_markers.dart';
import 'package:fogospt/features/map/application/map_latest_warnings/map_latest_warning_marker_cubit.dart';
import 'package:fogospt/features/map/presentation/pages/views/map_page_modal_content_view.dart';
import 'package:latlong2/latlong.dart';
import 'package:warnings/warnings.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class MapPageView extends StatelessWidget {
  const MapPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MapLatestWarningMarkerCubit>().state; 
    return Stack(
      children: [
        FlutterMap(
          options: FiresMapConfiguration.getMapOptions(),
          children: [
            FiresMapConfiguration.getTileLayer(),
            MarkerLayer(
              markers: state.activeWarnings.map((Fire fire) {
                return FireMarker(
                  point: LatLng(fire.lat, fire.lng),
                  type: switch (fire.statusCode) {
                    5 || 7 || 99 || 8 => WarningMarkerType.fire,
                    3 || 4 => WarningMarkerType.alarm,
                    9 => WarningMarkerType.watch,
                    6 || 10 => WarningMarkerType.pointer,
                    11 || 12 => WarningMarkerType.fake,
                    _ => WarningMarkerType.unknown,
                  },
                  importance: fire.important
                      ? MarkerImportance.high
                      : MarkerImportance.medium,
                  color: fire.statusColor.toFiresMapMarkerColor(),
                  onTap: () => _showBottomModal(context, fire),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }
}

class FireMarker extends Marker {
  FireMarker({
    required super.point,
    required WarningMarkerType type,
    required MarkerImportance importance,
    required Color color,
    required void Function() onTap,
  }) : super(
         child: _FireMarkerWidget(type: type, color: color, onTap: onTap),
         width: importance.size,
         height: importance.size,
       );
}

class _FireMarkerWidget extends StatelessWidget {
  final WarningMarkerType type;
  final Color color;
  final void Function() onTap;
  const _FireMarkerWidget({
    required this.type,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 50,
        width: 50,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SvgPicture.asset(height: 30, type.icon),
            ),
          ],
        ),
      ),
    );
  }
}

Future<dynamic> _showBottomModal(BuildContext context, Fire fire) {
  return WoltModalSheet.show(
    context: context,
    pageListBuilder: (modalSheetcontext) {
      return [_buildModalSheetPage(modalSheetcontext, fire)];
    },
    modalTypeBuilder: (context) => WoltBottomSheetType(),
  );
}

WoltModalSheetPage _buildModalSheetPage(BuildContext context, Fire fire) {
  return WoltModalSheetPage(
    hasSabGradient: false,
    isTopBarLayerAlwaysVisible: false,
    hasTopBarLayer: false,
    child: MapPageModalContentView(fire: fire),
  );
}
