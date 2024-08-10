import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fogos_api/features/latest_warnings/domain/fire.dart';
import 'package:fogospt/constants/assets.dart';
import 'package:fogospt/constants/colors.dart';
import 'package:fogospt/features/map/application/fires_map_markers.dart';
import 'package:fogospt/features/map/application/map_latest_fires/map_latest_fires_cubit.dart';
import 'package:fogospt/features/map/application/map_latest_fires/map_latest_fires_state.dart';
import 'package:fogospt/features/map/presentation/pages/views/map_page_error_view.dart';
import 'package:fogospt/features/map/presentation/pages/views/map_page_initial_view.dart';
import 'package:fogospt/features/map/presentation/pages/views/map_page_loading_view.dart';
import 'package:fogospt/features/map/presentation/pages/views/map_page_modal_content_view.dart';
import 'package:fogospt/features/map/presentation/pages/views/map_page_view.dart';
import 'package:fogospt/routing/message_watcher.dart';
import 'package:fogospt/utils/notifications/notification_helpers.dart';
import 'package:go_router/go_router.dart';
import 'package:warnings/warnings.dart';
import 'package:warnings_core/warnings_core.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class FiresMapPage extends StatefulWidget {
  @override
  State<FiresMapPage> createState() => _FiresMapPageState();
}

class _FiresMapPageState extends State<FiresMapPage> with MessageWatcherBase {
  @override
  void initState() {
    super.initState();
    setupFirebaseMessaging();

    processMessage = (message) {
      final fireId = message.data['fireId'];
      context.go('/fire-detail', extra: fireId);

      NotificationHelpers.showNotification(message);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: appFogosOrange,
        title: Text('Fogos.pt'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            /// Header
            DrawerHeader(
              child: Center(child: icoFire),
              decoration: BoxDecoration(
                color: appFogosOrange,
              ),
            ),

            ListTile(
              title: Text(
                'Notificações',
                style: context.textTheme.bodyLarge,
              ),
              onTap: () {
                context.go('/notifications');
              },
            ),
          ],
        ),
      ),
      body: BlocBuilder<MapLatestFiresCubit, MapLatestFiresState>(
        builder: (context, state) {
          switch (state) {
            case MapLatestFiresStateInitial():
              context.read<MapLatestFiresCubit>().fetchLatestFires();
              return MapPageInitialView();
            case MapLatestFiresStateLoading():
              return MapPageLoadingView();
            case MapLatestFiresStateLoaded():
              FiresMapMarkers mapMarkers = FiresMapMarkers(
                fires: state.fires,
                onMarkerTapped: (Fire fire) {
                  log(fire);
                  _showBottomModal(context, fire);
                },
              );
              return MapPageView(mapMarkers: mapMarkers);
            case MapLatestFiresStateFailed():
              return MapPageErrorView();
          }
        },
      ),
    );
  }

  Future<dynamic> _showBottomModal(BuildContext context, Fire fire) {
    return WoltModalSheet.show(
      context: context,
      pageListBuilder: (modalSheetcontext) {
        return [
          buildModalSheetPage(modalSheetcontext, fire),
        ];
      },
      modalTypeBuilder: (context) => WoltBottomSheetType(),
    );
  }

  WoltModalSheetPage buildModalSheetPage(
    BuildContext context,
    Fire fire,
  ) {
    return WoltModalSheetPage(
      hasSabGradient: false,
      isTopBarLayerAlwaysVisible: false,
      hasTopBarLayer: false,
      child: MapPageModalContentView(
        fire: fire,
      ),
    );
  }
}
