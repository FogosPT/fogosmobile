import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fogospt/constants/assets.dart';
import 'package:fogospt/constants/colors.dart';
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
import 'package:warnings_core/constants/date_formats.dart';

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
        FireService.FireService(),
      )..fetchAllFireInformation(fireId),
      child: BlocBuilder<FiresCubit, FiresState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return switch (state.status) {
            StateStatus.success ||
            StateStatus.initial ||
            StateStatus.loading =>
              FireDetailPageViewSuccess(),
            StateStatus.failure => FireDetailPageViewFailed(),
          };
        },
      ),
    );
  }
}

class FireDetailPageViewFailed extends StatelessWidget {
  const FireDetailPageViewFailed({
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

class FireDetailPageViewLoading extends StatelessWidget {
  const FireDetailPageViewLoading({
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

class FireDetailPageViewSuccess extends StatelessWidget {
  const FireDetailPageViewSuccess({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FiresCubit>().state;
    return Scaffold(
      appBar: FireAppBar(warning: state.fire),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppFogosTitleWidget(title: context.l10n.fires_map_page_local),
              BlocBuilder<FiresCubit, FiresState>(
                buildWhen: (previous, current) => previous.fire != current.fire,
                builder: (context, state) => StateWidget.simpleWithConditionals(
                  state,
                  child: Text(
                    state.fire?.location ?? '-',
                    style: context.textTheme.headlineSmall,
                  ),
                  onSuccessExtraConditionals: state.fire != null,
                ),
              ),

              SizedBox(height: 20),

              /// Resources
              AppFogosTitleWidget(title: context.l10n.fire_detail_means),
              StateWidget.simple(
                state,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconAndValueWidget(
                      icon: FogosAppAssets.getAsset(ResourcesType.man),
                      value: state.latestResourceMan,
                    ),
                    IconAndValueWidget(
                      icon: FogosAppAssets.getAsset(ResourcesType.terrain),
                      value: state.latestResourceTerrain,
                    ),
                    IconAndValueWidget(
                      icon: FogosAppAssets.getAsset(ResourcesType.aerial),
                      value: state.latestResourceAerial,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              /// Resources Graph
              StateWidget.simple(
                state,
                child: LayoutBuilder(
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
                ),
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
              AppFogosTitleWidget(title: context.l10n.fires_map_page_start),
              StateWidget.simpleWithConditionals(
                state,
                child: Text(
                  "${state.fire?.date ?? '-'} ${state.fire?.hour ?? '-'}",
                  style: context.textTheme.headlineSmall,
                ),
                onSuccessExtraConditionals: state.fire != null,
              ),
              SizedBox(height: 20),

              /// Natureza
              AppFogosTitleWidget(title: context.l10n.fires_map_page_nature),
              StateWidget.simpleWithConditionals(
                state,
                onSuccessExtraConditionals:
                    state.isSuccess && state.fire != null,
                child: Text(
                  state.fire?.natureza ?? '-',
                  style: context.textTheme.headlineSmall,
                ),
              ),
              SizedBox(height: 20),

              /// FONTE DE ALERTA
              // AppFogosTitleWidget(title: "fonte de alerta"),
              // SizedBox(height: 20),

              /// Risco de Incêndio
              AppFogosTitleWidget(
                  title: context.l10n.fires_map_page_risk_of_fire),

              if (state.latestRCM != null)
                StateWidget.simple(
                  state,
                  child: FireRiskWidget(rcm: state.latestRCM!),
                ),
              SizedBox(height: 20),

              /// ESTADO
              AppFogosTitleWidget(title: context.l10n.fires_map_page_state),
              Column(
                children: state.historyStatuses
                    .map<Widget>(
                      (status) => Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IntrinsicHeight(
                            child: Stack(
                              alignment: AlignmentDirectional.topCenter,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                status.label,
                                style: context.textTheme.bodyLarge
                                    ?.copyWith(color: appFogosOrange),
                              ),
                              Text(
                                status.status,
                                style: context.textTheme.bodyMedium,
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),

              /// METEO?
              Visibility(
                // visible: kDebugMode,
                visible: false,
                child: AppFogosTitleWidget(
                    title: context.l10n.fires_map_page_meteo),
              ),

              /// PARTILHAR
              Visibility(
                // visible: kDebugMode,
                visible: false,
                child: AppFogosTitleWidget(
                  title: context.l10n.fires_map_page_share,
                ),
              ),
            ],
          ),
        ),
      ),
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
    /// If we need to show more information we can use WarningFlChartData
    /// final data = getIt<WarningFlChartData>();
    return SideTitles(
      showTitles: false,
      getTitlesWidget: (value, meta) {
        final dateTime = DateTime.fromMillisecondsSinceEpoch(value.toInt());
        return SideTitleWidget(
          axisSide: meta.axisSide,
          angle: 125,
          child: Text(
            DateFormat(dateFormatDayMonthHourMinutes).format(dateTime),
          ),
        );
      },
    );
  }
}
