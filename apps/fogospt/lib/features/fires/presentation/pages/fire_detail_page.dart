import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fogos_api/features/latest_warnings/data/fires_repository.dart';
import 'package:fogos_api/shared/dependency_injection.dart';
import 'package:fogospt/constants/assets.dart';
import 'package:fogospt/constants/colors.dart';
import 'package:fogospt/constants/date_formats.dart';
import 'package:fogospt/features/fires/application/fires/fires_cubit.dart';
import 'package:fogospt/features/fires/application/fires/fires_state.dart';
import 'package:fogospt/features/fires/data/fire_service.dart';
import 'package:fogospt/features/fires/data/fires_flchart_data.dart';
import 'package:fogospt/features/fires/presentation/fire_app_bar.dart';
import 'package:fogospt/features/fires/presentation/widgets/fire_risk_state_icon_widget.dart';
import 'package:fogospt/features/fires/presentation/widgets/fire_risk_widget.dart';
import 'package:fogospt/features/fires/presentation/widgets/warning_chart_labels_item_widget.dart';
import 'package:fogospt/features/fires/presentation/widgets/warning_chart_labels_widget.dart';
import 'package:fogospt/widgets/app_fogos_title_widget.dart';
import 'package:intl/intl.dart';
import 'package:warnings/warnings.dart';

class FireDetailPage extends StatelessWidget {
  final String fireId;
  const FireDetailPage({
    super.key,
    required this.fireId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FiresCubit(
        FireService.FireService(
          getIt<FiresRepository>(),
        ),
      ),
      child: BlocBuilder<FiresCubit, FiresState>(
        builder: (context, state) {
          switch (state) {
            case FiresStateInitial():
              BlocProvider.of<FiresCubit>(context)
                  .fetchAllFireInformation(fireId);
              return FireLoadingView();
            case FiresStateLoading():
              return FireLoadingView();
            case FiresStateLoaded():
              return FireLoadedView();
            case FiresStateFailed():
              return FireFailedView();
          }
        },
      ),
    );
  }
}

class FireFailedView extends StatelessWidget {
  const FireFailedView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FireAppBar(),
      body: Center(
        child: Text('Não encontramos esse fogo.'),
      ),
    );
  }
}

class FireLoadingView extends StatelessWidget {
  const FireLoadingView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FireAppBar(),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class FireLoadedView extends StatelessWidget {
  const FireLoadedView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FiresCubit, FiresState>(
      builder: (context, state) {
        return Scaffold(
          appBar: FireAppBar(
              warning: state is FiresStateLoaded ? state.fire : null),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppFogosTitleWidget(title: "LOCAL"),
                  BlocBuilder<FiresCubit, FiresState>(
                    builder: (context, state) {
                      if (state is FiresStateFailed) {
                        throw Exception('Failed to load fire');
                      }
                      if (state is FiresStateLoaded) {
                        return Text(
                          state.fire?.location ?? '-',
                          style: context.textTheme.headlineSmall,
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                  SizedBox(height: 20),

                  /// Resources
                  AppFogosTitleWidget(title: "meios"),
                  BlocBuilder<FiresCubit, FiresState>(
                    builder: (context, state) {
                      if (state is FiresStateFailed) {
                        throw Exception('Failed to load fire');
                      }
                      if (state is FiresStateLoaded) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconAndValueWidget(
                              icon: FogosAppAssets.getAsset(ResourcesType.man),
                              value: state.latestResource?.man ?? 0,
                            ),
                            IconAndValueWidget(
                              icon: FogosAppAssets.getAsset(
                                  ResourcesType.terrain),
                              value: state.latestResource?.terrain ?? 0,
                            ),
                            IconAndValueWidget(
                              icon:
                                  FogosAppAssets.getAsset(ResourcesType.aerial),
                              value: state.latestResource?.aerial ?? 0,
                            ),
                          ],
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                  SizedBox(height: 20),

                  /// Resources Graph
                  BlocBuilder<FiresCubit, FiresState>(
                    builder: (context, state) {
                      if (state is FiresStateFailed) {
                        throw Exception('Failed to load fire');
                      }
                      if (state is FiresStateLoaded) {
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            final data = WarningFlChartData(
                              resources: state.resources ?? [],
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
                                        color: resourceManColor,
                                        barWidth: 4,
                                      ),
                                      LineChartBarData(
                                        spots: data.terrainToFlSpots(),
                                        color: resourceTerrainColor,
                                        barWidth: 4,
                                      ),
                                      LineChartBarData(
                                        spots: data.aerialToFlSpots(),
                                        color: resourceAerialColor,
                                        barWidth: 4,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                  SizedBox(height: 10),

                  /// Labels
                  WarningChartLabels.spaceEvenly(
                    labels: [
                      WarningChartLabelsItemWidget(
                        color: resourceManColor,
                        label: 'Operacionais',
                      ),
                      WarningChartLabelsItemWidget(
                        color: resourceTerrainColor,
                        label: 'Terrestres',
                      ),
                      WarningChartLabelsItemWidget(
                        color: resourceAerialColor,
                        label: 'Aéreos',
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  /// Inicio
                  AppFogosTitleWidget(title: "início"),
                  BlocBuilder<FiresCubit, FiresState>(
                    builder: (context, state) {
                      if (state is FiresStateLoaded) {
                        return Text(
                          "${state.fire?.date} ${state.fire?.hour}",
                          style: context.textTheme.headlineSmall,
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),
                  SizedBox(height: 20),

                  /// Natureza
                  AppFogosTitleWidget(title: "natureza"),
                  BlocBuilder<FiresCubit, FiresState>(
                    builder: (context, state) {
                      if (state is FiresStateLoaded) {
                        return Text(
                          state.fire?.natureza ?? '-',
                          style: context.textTheme.headlineSmall,
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),
                  SizedBox(height: 20),

                  /// FONTE DE ALERTA
                  // AppFogosTitleWidget(title: "fonte de alerta"),
                  // SizedBox(height: 20),

                  /// Risco de Incêndio
                  AppFogosTitleWidget(title: "risco de incêndio"),

                  BlocBuilder<FiresCubit, FiresState>(
                    builder: (context, state) {
                      if (state is FiresStateLoaded) {
                        if (state.latestRCM != null) {
                          return FireRiskWidget(rcm: state.latestRCM!);
                        }
                      }
                      return SizedBox.shrink();
                    },
                  ),
                  SizedBox(height: 20),

                  /// ESTADO
                  AppFogosTitleWidget(title: "estado"),
                  BlocBuilder<FiresCubit, FiresState>(
                    builder: (context, state) {
                      if (state is FiresStateLoaded) {
                        return Column(
                          children: [
                            ...state.historyStatuses?.map<Widget>(
                                  (status) {
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        IntrinsicHeight(
                                          child: Stack(
                                            alignment:
                                                AlignmentDirectional.topCenter,
                                            children: [
                                              RiskFireStateIconWidget(
                                                status: status,
                                                icon: icoFire,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 1.5),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              status.label,
                                              style: context.textTheme.bodyLarge
                                                  ?.copyWith(
                                                      color: appFogosOrange),
                                            ),
                                            Text(
                                              status.status,
                                              style:
                                                  context.textTheme.bodyMedium,
                                            ),
                                            SizedBox(height: 20),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ).toList() ??
                                [],
                          ],
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),

                  /// METEO?
                  Visibility(
                    // visible: kDebugMode,
                    visible: false,
                    child: AppFogosTitleWidget(title: "meteo"),
                  ),

                  /// PARTILHAR
                  Visibility(
                    // visible: kDebugMode,
                    visible: false,
                    child: AppFogosTitleWidget(title: "partilhar"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  LineTouchData lineTouchData() {
    return LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (touchedSpot) => Colors.lightGreen,
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
        sideTitles: daysOfWeekBottomTitle(),
      ),
    );
  }

  SideTitles daysOfWeekBottomTitle() {
    // final data = getIt<WarningFlChartData>();
    return SideTitles(
      showTitles: false,
      getTitlesWidget: (value, meta) {
        final dateTime = DateTime.fromMillisecondsSinceEpoch(value.toInt());
        ;
        return SideTitleWidget(
          axisSide: meta.axisSide,
          angle: 125,
          child:
              Text(DateFormat(dateFormatDayMonthHourMinutes).format(dateTime)),
        );
      },
    );
  }
}
