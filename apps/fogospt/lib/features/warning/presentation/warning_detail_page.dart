import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fogos_api/features/latest_warnings/data/fires_repository.dart';
import 'package:fogos_api/features/latest_warnings/domain/fire.dart';
import 'package:fogos_api/shared/dependency_injection.dart';
import 'package:fogospt/features/warning/application/warning_cubit.dart';
import 'package:fogospt/features/warning/application/warning_flchart_data.dart';
import 'package:fogospt/features/warning/application/warning_state.dart';
import 'package:fogospt/features/warning/data/warning_service.dart';
import 'package:fogospt/features/warning/presentation/warning_app_bar.dart';
import 'package:fogospt/features/warning/presentation/warning_chart_label.dart';

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
            body: SingleChildScrollView(
              child: Column(
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
                  SizedBox(
                    height: 20,
                  ),

                  /// Labels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      WarningChartLabel(
                        color: Colors.yellow,
                        label: 'Operacionais',
                      ),
                      WarningChartLabel(
                        color: Colors.green,
                        label: 'Terrestres',
                      ),
                      WarningChartLabel(
                        color: Colors.blue,
                        label: 'Aéreos',
                      ),
                    ],
                  ),

                  /// Graph
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final data = WarningFlChartData(
                        resources: state.resources,
                      );
                      return SizedBox.fromSize(
                        size: Size(constraints.maxWidth, 300),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LineChart(
                            LineChartData(
                              minY: 0,
                              maxY: data.axisY(),
                              titlesData: titlesData(),
                              lineTouchData: lineTouchData(),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: data.manToFlSpots(),
                                  color: Colors.yellow,
                                  barWidth: 4,
                                ),
                                LineChartBarData(
                                  spots: data.terrainToFlSpots(),
                                  color: Colors.green,
                                  barWidth: 4,
                                ),
                                LineChartBarData(
                                  spots: data.aerialToFlSpots(),
                                  color: Colors.blue,
                                  barWidth: 5,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // Links
                ],
              ),
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

  LineTouchData lineTouchData() {
    return LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (touchedSpot) => Colors.transparent,
      ),
    );
  }

  FlTitlesData titlesData() {
    return FlTitlesData(
      topTitles: AxisTitles(
        axisNameWidget: Text('Meios'),
        axisNameSize: 20,
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      leftTitles: AxisTitles(
        axisNameWidget: Text('Meios'),
        axisNameSize: 0,
        sideTitles: SideTitles(
          showTitles: true,
          interval: 10,
          getTitlesWidget: (value, meta) => Text(value.toInt().toString()),
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: true),
        // sideTitles: daysOfWeekBottomTitle()
      ),
    );
  }
}
