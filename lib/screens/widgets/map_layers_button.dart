import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/actions/ipma_actions.dart';
import 'package:fogosmobile/actions/modis_actions.dart';
import 'package:fogosmobile/actions/viirs_actions.dart';
import 'package:fogosmobile/constants/ipma_layers.dart';
import 'package:fogosmobile/middleware/preferences_middleware.dart';
import 'package:fogosmobile/actions/preferences_actions.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:redux/redux.dart';

class MapLayersButton extends StatelessWidget {
  const MapLayersButton({Key? key}) : super(key: key);

  void _openLayersSheet(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    if (!store.state.ipmaReferenceTimeLoaded) {
      store.dispatch(LoadIpmaReferenceTimeAction());
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => StoreConnector<AppState, AppState>(
        converter: (Store<AppState> store) => store.state,
        builder: (context, state) {
          final store = StoreProvider.of<AppState>(context);
          final satelliteActive =
              state.preferences[preferenceSatellite] == 1;
          final activeIpma = state.activeIpmaLayers;
          final aromeReady = state.ipmaReferenceTime != null &&
              state.ipmaReferenceTime!.isNotEmpty;
          final aromeFailed =
              state.ipmaReferenceTimeLoaded && !aromeReady;

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _LayerTile(
                    icon: Icons.satellite_alt,
                    label: 'Satélite',
                    active: satelliteActive,
                    onTap: () => store.dispatch(SetPreferenceAction(
                        preferenceSatellite, satelliteActive ? 0 : 1)),
                  ),
                  _LayerTile(
                    icon: Icons.local_fire_department_outlined,
                    label: 'Outros fogos',
                    active: state.showNatureCodes,
                    onTap: () => store.dispatch(ToggleNatureCodesAction()),
                  ),
                  const _SectionHeader(label: 'Hotspots satélite'),
                  _LayerTile(
                    icon: Icons.blur_on,
                    label: 'VIIRS',
                    active: state.showViirs,
                    onTap: () {
                      if (!state.showViirs) store.dispatch(LoadViirsAction());
                      store.dispatch(ShowViirsAction());
                    },
                  ),
                  _LayerTile(
                    icon: Icons.blur_circular,
                    label: 'MODIS',
                    active: state.showModis,
                    onTap: () {
                      if (!state.showModis) store.dispatch(LoadModisAction());
                      store.dispatch(ShowModisAction());
                    },
                  ),
                  _LayerTile(
                    icon: Icons.whatshot,
                    label: ipmaFrpGroup.label,
                    active: activeIpma.contains(ipmaFrpGroup.key),
                    onTap: () => store
                        .dispatch(ToggleIpmaLayerAction(ipmaFrpGroup.key)),
                  ),
                  const _SectionHeader(label: 'Previsão IPMA'),
                  if (!aromeReady)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: Row(
                        children: [
                          if (!aromeFailed)
                            const SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          else
                            const Icon(Icons.error_outline,
                                size: 14, color: Colors.black54),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              aromeFailed
                                  ? 'Previsão indisponível, tentar mais tarde'
                                  : 'A obter modelo IPMA…',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ),
                  for (final group in ipmaAromeGroups)
                    _LayerTile(
                      icon: _iconForIpma(group.key),
                      label: group.label,
                      active: activeIpma.contains(group.key),
                      enabled: aromeReady,
                      onTap: () =>
                          store.dispatch(ToggleIpmaLayerAction(group.key)),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static IconData _iconForIpma(String key) {
    switch (key) {
      case 'ipma-temperature':
        return Icons.thermostat;
      case 'ipma-wind':
        return Icons.air;
      case 'ipma-wind-direction':
        return Icons.navigation;
      case 'ipma-precipitation':
        return Icons.umbrella;
      case 'ipma-humidity':
        return Icons.water_drop;
      default:
        return Icons.layers;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (Store<AppState> store) => store.state,
      builder: (context, state) {
        final anyActive = state.preferences[preferenceSatellite] == 1 ||
            state.showViirs ||
            state.showModis ||
            state.showNatureCodes ||
            state.activeIpmaLayers.isNotEmpty;

        return GestureDetector(
          onTap: () => _openLayersSheet(context),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Icon(Icons.layers, size: 26),
              ),
              if (anyActive)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Color(0xff3BB273),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}

class _LayerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final bool enabled;
  final VoidCallback onTap;

  const _LayerTile({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final Widget trailing = Icon(
      active ? Icons.check_circle : Icons.radio_button_unchecked,
      color: !enabled
          ? Colors.grey.shade300
          : (active ? const Color(0xff3BB273) : Colors.grey),
    );
    return ListTile(
      enabled: enabled,
      leading: Icon(icon, color: enabled ? null : Colors.grey),
      title: Text(label,
          style: TextStyle(color: enabled ? null : Colors.grey)),
      trailing: trailing,
      onTap: enabled ? onTap : null,
    );
  }
}
