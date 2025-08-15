import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fogospt/constants/assets.dart';
import 'package:fogospt/constants/colors.dart';
import 'package:fogospt/features/map/application/map_latest_warnings/map_latest_warning_marker_cubit.dart';
import 'package:fogospt/features/map/application/map_latest_warnings/map_latest_warning_marker_state.dart';
import 'package:fogospt/features/map/presentation/pages/views/map_page_error_view.dart';
import 'package:fogospt/features/map/presentation/pages/views/map_page_view.dart';
import 'package:fogospt/routing/app_go_router.dart';
import 'package:fogospt/routing/message_watcher.dart';
import 'package:fogospt/utils/extentions/build_context.dart';
import 'package:fogospt/utils/notifications/notification_helpers.dart';
import 'package:warnings/warnings.dart';
import 'package:warnings_core/widget/current_version_text.dart';

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
    context.read<MapLatestWarningMarkerCubit>().fetchLatestFires();
    _timer = Timer.periodic(
      kDebugMode ? Duration(seconds: 10) : refreshInterval,
      (timer) {
        context.read<MapLatestWarningMarkerCubit>().fetchLatestFires();
        if (kDebugMode) {
          debugPrint('Fetching latest fires at ${DateTime.now()}');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: appFogosOrange,
        title: Text(context.l10n_fogos.fogospt),
      ),
      drawer: Drawer(
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /// Header
            DrawerHeader(
              child: Center(child: icoFire),
              decoration: BoxDecoration(color: appFogosOrange),
            ),
            /// Fire List
            TextButton(
              onPressed: () => FiresMapPageFireListRoute().go(context),
              child: Text(
                context.l10n_fogos.fires_map_page_fire_list,
                style: context.textTheme.bodyLarge,
              ),
              style: TextButton.styleFrom(shape: RoundedRectangleBorder()),
            ),

            /// Warnings
            TextButton(
              onPressed: () => FiresMapPageWarningsRoute().go(context),
              child: Text(
                context.l10n_fogos.fires_map_page_warnings,
                style: context.textTheme.bodyLarge,
              ),
              style: TextButton.styleFrom(shape: RoundedRectangleBorder()),
            ),

            /// Warnings Madeira
            TextButton(
              onPressed: () => FiresMapPageWarningsMadeiraRoute().go(context),
              child: Text(
                context.l10n_fogos.fires_map_page_warnings_madeira,
                style: context.textTheme.bodyLarge,
              ),
              style: TextButton.styleFrom(shape: RoundedRectangleBorder()),
            ),

            /// Informations
            TextButton(
              onPressed: () => FiresMapPageInformationsRoute().go(context),
              child: Text(
                context.l10n_fogos.fires_map_page_informations,
                style: context.textTheme.bodyLarge,
              ),
              style: TextButton.styleFrom(shape: RoundedRectangleBorder()),
            ),

            /// Statistics
            TextButton(
              onPressed: () => FiresMapPageStatisticsRoute().go(context),
              child: Text(
                context.l10n_fogos.fires_map_page_statistics,
                style: context.textTheme.bodyLarge,
              ),
              style: TextButton.styleFrom(shape: RoundedRectangleBorder()),
            ),
            Divider(),

            /// Notifications Generic
            TextButton(
              onPressed: () => NotificationsGenericRoute().go(context),
              child: Text(
                context.l10n_fogos.fires_map_page_notifications,
                style: context.textTheme.bodyLarge,
              ),
              style: TextButton.styleFrom(shape: RoundedRectangleBorder()),
            ),

            /// Notifications List Municipalities
            TextButton(
              onPressed: () =>
                  NotificationsListMunicipalitiesRoute().go(context),
              child: Text(
                context
                    .l10n_fogos
                    .fires_map_page_notifications_list_municipalities,
                style: context.textTheme.bodyLarge,
              ),
              style: TextButton.styleFrom(shape: RoundedRectangleBorder()),
            ),
            Divider(),

            /// About
            TextButton(
              onPressed: () => FiresMapPageAboutRoute().go(context),
              child: Text(
                context.l10n_fogos.fires_map_page_about,
                style: context.textTheme.bodyLarge,
              ),
              style: TextButton.styleFrom(shape: RoundedRectangleBorder()),
            ),

            /// Partners
            TextButton(
              onPressed: () => FiresMapPagePartnersRoute().go(context),
              child: Text(
                context.l10n_fogos.fires_map_page_partners,
                style: context.textTheme.bodyLarge,
              ),
              style: TextButton.styleFrom(shape: RoundedRectangleBorder()),
            ),
            Spacer(),
            Center(
              child: CurrentVersionText(
                style: context.textTheme.bodyMedium?.apply(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      body:
          BlocBuilder<MapLatestWarningMarkerCubit, MapLatestWarningMarkerState>(
            buildWhen: (previous, current) =>
                previous.activeWarnings != current.activeWarnings,
        builder: (context, state) {
          return switch (state.status) {
            StateStatus.failure => MapPageErrorView(),
            StateStatus.success ||
            StateStatus.initial ||
            StateStatus.loading =>
              MapPageView(),
          };
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
