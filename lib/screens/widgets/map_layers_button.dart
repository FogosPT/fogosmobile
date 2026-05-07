import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/actions/modis_actions.dart';
import 'package:fogosmobile/actions/viirs_actions.dart';
import 'package:fogosmobile/middleware/preferences_middleware.dart';
import 'package:fogosmobile/actions/preferences_actions.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:redux/redux.dart';

class MapLayersButton extends StatelessWidget {
  const MapLayersButton({Key? key}) : super(key: key);

  void _openLayersSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => StoreConnector<AppState, AppState>(
        converter: (Store<AppState> store) => store.state,
        builder: (context, state) {
          final store = StoreProvider.of<AppState>(context);
          final satelliteActive =
              state.preferences[preferenceSatellite] == 1;

          return SafeArea(
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
                  icon: Icons.blur_on,
                  label: 'VIIRS',
                  active: state.showViirs,
                  onTap: () => store.dispatch(ShowViirsAction()),
                ),
                _LayerTile(
                  icon: Icons.blur_circular,
                  label: 'MODIS',
                  active: state.showModis,
                  onTap: () => store.dispatch(ShowModisAction()),
                ),
                _LayerTile(
                  icon: Icons.local_fire_department_outlined,
                  label: 'Outros fogos',
                  active: state.showNatureCodes,
                  onTap: () => store.dispatch(ToggleNatureCodesAction()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (Store<AppState> store) => store.state,
      builder: (context, state) {
        final anyActive = state.preferences[preferenceSatellite] == 1 ||
            state.showViirs ||
            state.showModis ||
            state.showNatureCodes;

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

class _LayerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _LayerTile({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: Icon(
        active ? Icons.check_circle : Icons.radio_button_unchecked,
        color: active ? Color(0xff3BB273) : Colors.grey,
      ),
      onTap: onTap,
    );
  }
}
