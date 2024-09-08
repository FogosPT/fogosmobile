import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fogospt/features/map/application/map_latest_fires/map_latest_fires_cubit.dart';
import 'package:fogospt/features/map/application/map_latest_fires/map_latest_fires_state.dart';
import 'package:warnings/state_management/state_status.dart';
import 'package:warnings/utils/extensions/context_extensions.dart';

class ListFiresPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<MapLatestFiresCubit, MapLatestFiresState>(
          builder: (context, state) {
            return switch (state.status) {
              StateStatus.success => ListView.builder(
                  itemCount: state.fires.length,
                  itemBuilder: (context, index) {
                    final fire = state.fires[index];
                    return ListTile(
                      title: Text(fire.location),
                      subtitle: Text(fire.status),
                    );
                  },
                ),
              StateStatus.failure => Center(
                  child: Text(context.l10n.fires_map_page_error),
                ),
              _ => Center(child: CircularProgressIndicator()),
            };
          },
        ),
      ),
    );
  }
}
