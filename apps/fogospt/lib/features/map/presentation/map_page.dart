import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fogos_api/constants/logger.dart';
import 'package:fogos_api/features/latest_warnings/domain/fire.dart';
import 'package:fogospt/features/map/application/flutter_map_markers.dart';
import 'package:fogospt/features/map/application/latest_fires/latest_fires_cubit.dart';
import 'package:fogospt/features/map/application/latest_fires/latest_fires_state.dart';
import 'package:fogospt/features/map/presentation/map_page_error_view.dart';
import 'package:fogospt/features/map/presentation/map_page_initial_view.dart';
import 'package:fogospt/features/map/presentation/map_page_loading_view.dart';
import 'package:fogospt/features/map/presentation/map_page_modal_content.dart';
import 'package:fogospt/features/map/presentation/map_page_view.dart';
import 'package:go_router/go_router.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LatestFiresCubit, LatestFiresState>(
        builder: (context, state) {
          return state.when(
            initial: () {
              context.read<LatestFiresCubit>().fetchLatestFires();
              return MapPageInitialView();
            },
            loading: () => MapPageLoadingView(),
            loaded: (fires) {
              log(fires);
              FlutterMapMarkers mapMarkers = FlutterMapMarkers(
                fires: fires,
                onMarkerTapped: (Fire fire) {
                  log(fire);
                  showBottomModal(context, fire);
                },
              );
              return MapPageView(mapMarkers: mapMarkers);
            },
            error: () => MapPageErrorView(),
          );
        },
      ),
    );
  }

  Future<dynamic> showBottomModal(BuildContext context, Fire fire) {
    return WoltModalSheet.show(
      context: context,
      pageListBuilder: (modalSheetcontext) {
        return [
          buildModalSheetPage(fire, modalSheetcontext),
        ];
      },
      modalTypeBuilder: (context) => WoltBottomSheetType(),
    );
  }

  WoltModalSheetPage buildModalSheetPage(Fire fire, BuildContext context) {
    return WoltModalSheetPage(
      stickyActionBar: TextButton(
        onPressed: () {
          context.go('/warning-detail', extra: fire);
          context.pop();
        },
        child: FireModalSeeMore(fire: fire),
      ),
      isTopBarLayerAlwaysVisible: true,
      topBarTitle: Row(
        children: [
          Icon(Icons.share),
          Icon(Icons.notification_add),
          Icon(Icons.close),
        ],
      ),
      child: MapPageModalContent(
        fire: fire,
      ),
    );
  }
}

class FireModalSeeMore extends StatelessWidget {
  final Fire fire;
  const FireModalSeeMore({
    super.key,
    required this.fire,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go('/warning-detail', extra: fire);
        context.pop();
      },
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.blue,
          ),
          Text(
            'mais informações'.toUpperCase(),
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
