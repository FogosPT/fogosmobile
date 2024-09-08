import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fogos_api/features/latest_warnings/domain/fire.dart';
import 'package:fogospt/constants/assets.dart';
import 'package:fogospt/constants/colors.dart';
import 'package:fogospt/features/map/application/fires_map_markers.dart';
import 'package:fogospt/features/map/application/map_latest_fires/map_latest_fires_cubit.dart';
import 'package:fogospt/features/map/presentation/pages/views/map_page_error_view.dart';
import 'package:fogospt/features/map/presentation/pages/views/map_page_loading_view.dart';
import 'package:fogospt/features/map/presentation/pages/views/map_page_modal_content_view.dart';
import 'package:fogospt/features/map/presentation/pages/views/map_page_view.dart';
import 'package:fogospt/routing/app_go_router.dart';
import 'package:fogospt/routing/message_watcher.dart';
import 'package:fogospt/utils/notifications/notification_helpers.dart';
import 'package:warnings/warnings.dart';
import 'package:warnings_core/logger.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

/// The page that displays the fires on the map
class FiresMapPage extends StatefulWidget {
  @override
  State<FiresMapPage> createState() => _FiresMapPageState();
}

class _FiresMapPageState extends State<FiresMapPage> with MessageWatcherBase {
  late final Timer? _timer;

  /// The interval in which the fires are refreshed
  final Duration refreshInterval = Duration(minutes: 5);

  @override
  void initState() {
    super.initState();
    setupFirebaseMessaging();

    processMessage = (message) {
      var fireId = message.data['fireId'];
      if (fireId == null) {
        RootRoute().go(context);
      } else {
        FireDetailRoute(id: fireId).go(context);
      }

      NotificationHelpers.showNotification(message);
    };

    _startFetchTimer();
  }

  void _startFetchTimer() {
    _timer = Timer.periodic(
      kDebugMode ? Duration(seconds: 10) : refreshInterval,
      (timer) {
        context.read<MapLatestFiresCubit>().fetchLatestFires();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MapLatestFiresCubit>().state;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: appFogosOrange,
        title: Text(context.l10n.fogospt),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.all(8),
          children: <Widget>[
            /// Header
            DrawerHeader(
              child: Center(child: icoFire),
              decoration: BoxDecoration(
                color: appFogosOrange,
              ),
            ),

            ElevatedButton(
              onPressed: () =>
                  NotificationsListMunicipalitiesRoute().go(context),
              child: Text(
                context.l10n.fires_map_page_notifications_list_municipalities,
                style: context.textTheme.bodyLarge,
              ),
            ),
            ElevatedButton(
              onPressed: () => NotificationsGenericRoute().go(context),
              child: Text(
                context.l10n.fires_map_page_notifications,
                style: context.textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
      body: switch (state) {
        _ when state.isInitial || state.isSuccess || state.isLoading =>
          MapPageView(
            mapMarkers: FiresMapMarkers(
              fires: state.fires,
              onMarkerTapped: (Fire fire) {
                log(fire);
                _showBottomModal(context, fire);
              },
            ),
          ),
        _ when state.isFailure => MapPageErrorView(),
        _ => MapPageLoadingView(),
      },
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
