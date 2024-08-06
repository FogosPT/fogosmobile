import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fogos_api/features/latest_warnings/data/fires_repository.dart';
import 'package:fogos_api/features/latest_warnings/domain/fire.dart';
import 'package:fogos_api/shared/dependency_injection.dart';
import 'package:fogospt/features/warning/application/warning_cubit.dart';
import 'package:fogospt/features/warning/application/warning_state.dart';
import 'package:fogospt/features/warning/data/warning_service.dart';

class WarningDetailPage extends StatelessWidget {
  final Fire? warning;
  const WarningDetailPage({super.key, this.warning});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WarningCubit(
        WarningService(
          getIt<FiresRepository>(),
        ),
      ),
      child: BlocBuilder<WarningCubit, WarningState>(
        builder: (context, state) {
          switch (state) {
            case WarningInitial():
              BlocProvider.of<WarningCubit>(context)
                  .fetchWarning(warning?.id ?? '');
              return WarningLoadingView();
            case Loading():
              return WarningLoadingView();
            case WarningLoaded():
              return WarningLoadedView();
            case WarningFailed():
              return WarningFailedView();
          }
        },
      ),
    );
  }
}

class WarningFailedView extends StatelessWidget {
  const WarningFailedView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WarningAppBar(),
      body: Center(
        child: Text('Failed to load warning'),
      ),
    );
  }
}

class WarningLoadingView extends StatelessWidget {
  const WarningLoadingView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WarningAppBar(),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class WarningLoadedView extends StatelessWidget {
  const WarningLoadedView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WarningCubit, WarningState>(
      builder: (context, state) {
        if (state is WarningLoaded) {
          return Scaffold(
            appBar: WarningAppBar(warning: state.fire),
            body: Column(
              children: [
                // Notes
                Row(
                  children: [
                    Column(
                      children: [
                        Text('Bombeiros: ${state.resources.first.man}'),
                        Text('Veículos: ${state.resources.first.terrain}'),
                        Text('Meios Aéreos: ${state.resources.first.aerial}'),
                        Divider(),
                        Text(state.fire.updated.sec.toString()),
                      ],
                    ),
                    Column(
                      children: [
                        Text('${state.fire.district}'),
                        Text('${state.fire.concelho}'),
                        Text('${state.fire.freguesia}'),
                        Divider(),
                        Text('${state.rcm.first.hoje}'),
                      ],
                    ),
                  ],
                ),
                // Graph
                LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: state.resources
                            .asMap()
                            .entries
                            .map(
                              (entry) => FlSpot(
                                entry.key.toDouble(),
                                entry.value.man.toDouble(),
                              ),
                            )
                            .toList(),
                      ),
                      LineChartBarData(
                        spots: state.resources
                            .asMap()
                            .entries
                            .map(
                              (entry) => FlSpot(
                                entry.key.toDouble(),
                                entry.value.aerial.toDouble(),
                              ),
                            )
                            .toList(),
                      ),
                      LineChartBarData(
                        spots: state.resources
                            .asMap()
                            .entries
                            .map(
                              (entry) => FlSpot(
                                entry.key.toDouble(),
                                entry.value.terrain.toDouble(),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
                // Links
              ],
            ),
          );
        } else {
          return Scaffold(
            appBar: WarningAppBar(),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

class WarningAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WarningAppBar({
    super.key,
    this.warning,
  });

  final Fire? warning;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: Colors.deepPurple,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Text('Warning ${warning != null ? '- ${warning?.location}' : ''}'),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
