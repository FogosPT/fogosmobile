import 'dart:convert';
import 'dart:math';

import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';
import 'package:fogosmobile/constants/endpoints.dart';
import 'package:fogosmobile/models/ipma_point.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

const Color _kPrimary = Color(0xffF25C54);

class IpmaChartsCard extends StatefulWidget {
  final double lat;
  final double lng;

  const IpmaChartsCard({Key? key, required this.lat, required this.lng})
      : super(key: key);

  @override
  State<IpmaChartsCard> createState() => _IpmaChartsCardState();
}

class _IpmaChartsCardState extends State<IpmaChartsCard> {
  late Future<IpmaPointData?> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetch();
  }

  Future<IpmaPointData?> _fetch() async {
    try {
      final r = await http
          .get(Uri.parse(Endpoints.getIpmaPoint(widget.lat, widget.lng)))
          .timeout(const Duration(seconds: 15));
      if (r.statusCode != 200) return null;
      final j = jsonDecode(r.body) as Map<String, dynamic>;
      return IpmaPointData.fromJson(j);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<IpmaPointData?>(
      future: _future,
      builder: (ctx, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final data = snap.data;
        if (data == null || data.hourly.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              title: Text(
                'PREVISÃO IPMA NESTE PONTO',
                style: TextStyle(color: _kPrimary, fontSize: 20),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: _AttributionLine(),
            ),
            _ChartSection(
              title: 'Temperatura e humidade',
              child: _TempHumidityChart(hourly: data.hourly),
            ),
            _ChartSection(
              title: 'Vento e rajada',
              child: _WindChart(hourly: data.hourly),
            ),
            _ChartSection(
              title: 'Pressão atmosférica',
              child: _SingleHourlyLine(
                hourly: data.hourly,
                valueOf: (h) => h.pressure,
                label: 'Pressão (hPa)',
                color: _kPrimary,
              ),
            ),
            _ChartSection(
              title: 'Precipitação acumulada',
              child: _PrecipBars(hourly: data.hourly),
            ),
            _ChartSection(
              title: 'FWI / ISI / BUI',
              child: _MultiDailyLine(
                series: [
                  _DailySeriesSpec(
                      label: 'FWI',
                      color: Colors.red,
                      data: data.daily['fwi']),
                  _DailySeriesSpec(
                      label: 'ISI',
                      color: Colors.orange,
                      data: data.daily['isi']),
                  _DailySeriesSpec(
                      label: 'BUI',
                      color: Colors.brown,
                      data: data.daily['bui']),
                ],
              ),
            ),
            _ChartSection(
              title: 'DC / DMC / FFMC',
              child: _MultiDailyLine(
                series: [
                  _DailySeriesSpec(
                      label: 'DC',
                      color: Colors.deepPurple,
                      data: data.daily['dc']),
                  _DailySeriesSpec(
                      label: 'DMC',
                      color: Colors.indigo,
                      data: data.daily['dmc']),
                  _DailySeriesSpec(
                      label: 'FFMC',
                      color: Colors.teal,
                      data: data.daily['ffmc']),
                ],
              ),
            ),
            _ChartSection(
              title: 'FRM — probabilidade e anomalia',
              child: _MultiDailyLine(
                series: [
                  _DailySeriesSpec(
                      label: 'Prob. extremos',
                      color: Colors.red,
                      data: data.daily['p2000']),
                  _DailySeriesSpec(
                      label: 'Anomalia',
                      color: Colors.blueGrey,
                      data: data.daily['p2000a']),
                ],
              ),
            ),
            _ChartSection(
              title: 'RCM (estação)',
              child: _MultiDailyLine(
                series: [
                  _DailySeriesSpec(
                      label: 'RCM',
                      color: _kPrimary,
                      data: data.daily['rcm']),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AttributionLine extends StatelessWidget {
  const _AttributionLine();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse('https://www.ipma.pt'),
          mode: LaunchMode.externalApplication),
      child: const Text(
        'Dados: IPMA (modelo AROME + LSA-SAF)',
        style: TextStyle(
            fontSize: 11, color: Colors.black54, fontStyle: FontStyle.italic),
      ),
    );
  }
}

class _ChartSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _ChartSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87)),
          const SizedBox(height: 8),
          SizedBox(height: 180, child: child),
        ],
      ),
    );
  }
}

// ──────────── Charts ────────────

class _TempHumidityChart extends StatelessWidget {
  final List<IpmaHourly> hourly;
  const _TempHumidityChart({required this.hourly});

  @override
  Widget build(BuildContext context) {
    final temp = hourly
        .where((h) => h.temperature != null)
        .map((h) => _TimePoint(h.t, h.temperature!))
        .toList();
    final hum = hourly
        .where((h) => h.humidity != null)
        .map((h) => _TimePoint(h.t, h.humidity!))
        .toList();

    final tempSeries = charts.Series<_TimePoint, DateTime>(
      id: 'Temperatura (°C)',
      colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.red),
      domainFn: (p, _) => p.t,
      measureFn: (p, _) => p.v,
      data: temp,
    );
    final humSeries = charts.Series<_TimePoint, DateTime>(
      id: 'Humidade (%)',
      colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.blue),
      domainFn: (p, _) => p.t,
      measureFn: (p, _) => p.v,
      data: hum,
    )..setAttribute(charts.measureAxisIdKey, 'secondaryMeasureAxisId');

    return charts.TimeSeriesChart(
      [tempSeries, humSeries],
      animate: false,
      behaviors: [
        charts.SeriesLegend(
          position: charts.BehaviorPosition.bottom,
          horizontalFirst: true,
          cellPadding: const EdgeInsets.only(right: 12, bottom: 4),
        ),
      ],
      secondaryMeasureAxis: const charts.NumericAxisSpec(
        tickProviderSpec:
            charts.BasicNumericTickProviderSpec(desiredTickCount: 5),
      ),
      primaryMeasureAxis: const charts.NumericAxisSpec(
        tickProviderSpec:
            charts.BasicNumericTickProviderSpec(desiredTickCount: 5),
      ),
    );
  }
}

class _WindChart extends StatelessWidget {
  final List<IpmaHourly> hourly;
  const _WindChart({required this.hourly});

  @override
  Widget build(BuildContext context) {
    final wind = hourly
        .where((h) => h.wind != null)
        .map((h) => _TimePoint(h.t, h.wind!))
        .toList();
    final gust = hourly
        .where((h) => h.gust != null)
        .map((h) => _TimePoint(h.t, h.gust!))
        .toList();

    final chart = charts.TimeSeriesChart(
      [
        charts.Series<_TimePoint, DateTime>(
          id: 'Vento médio (km/h)',
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(_kPrimary),
          domainFn: (p, _) => p.t,
          measureFn: (p, _) => p.v,
          data: wind,
        ),
        charts.Series<_TimePoint, DateTime>(
          id: 'Rajada (km/h)',
          colorFn: (_, __) =>
              charts.ColorUtil.fromDartColor(Colors.orange.shade700),
          domainFn: (p, _) => p.t,
          measureFn: (p, _) => p.v,
          data: gust,
        ),
      ],
      animate: false,
      behaviors: [
        charts.SeriesLegend(
          position: charts.BehaviorPosition.bottom,
          horizontalFirst: true,
          cellPadding: const EdgeInsets.only(right: 12, bottom: 4),
        ),
      ],
    );

    return Stack(
      children: [
        chart,
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(painter: _WindArrowsPainter(hourly)),
          ),
        ),
      ],
    );
  }
}

class _WindArrowsPainter extends CustomPainter {
  final List<IpmaHourly> hourly;
  _WindArrowsPainter(this.hourly);

  @override
  void paint(Canvas canvas, Size size) {
    if (hourly.length < 2) return;
    const leftPad = 44.0;
    const rightPad = 12.0;
    const topPad = 6.0;
    final plotW = size.width - leftPad - rightPad;
    if (plotW <= 0) return;

    final step = hourly.length > 24 ? 3 : 2;
    final stroke = Paint()
      ..color = Colors.black87
      ..strokeWidth = 1.1
      ..style = PaintingStyle.stroke;
    final fill = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    for (var i = 0; i < hourly.length; i++) {
      if (i % step != 0) continue;
      final h = hourly[i];
      if (h.windU == null || h.windV == null) continue;
      final mag = sqrt(h.windU! * h.windU! + h.windV! * h.windV!);
      if (mag < 0.1) continue;
      final x = leftPad + plotW * (i / (hourly.length - 1));
      final y = topPad;
      final angle = atan2(-h.windV!, h.windU!);
      _drawArrow(canvas, Offset(x, y), angle, 10, stroke, fill);
    }
  }

  void _drawArrow(Canvas c, Offset center, double angle, double length,
      Paint stroke, Paint fill) {
    final dx = cos(angle) * length / 2;
    final dy = sin(angle) * length / 2;
    final tail = center.translate(-dx, -dy);
    final head = center.translate(dx, dy);
    c.drawLine(tail, head, stroke);
    final left = head.translate(
        cos(angle + pi - 0.5) * 4, sin(angle + pi - 0.5) * 4);
    final right = head.translate(
        cos(angle + pi + 0.5) * 4, sin(angle + pi + 0.5) * 4);
    final path = Path()
      ..moveTo(head.dx, head.dy)
      ..lineTo(left.dx, left.dy)
      ..lineTo(right.dx, right.dy)
      ..close();
    c.drawPath(path, fill);
  }

  @override
  bool shouldRepaint(covariant _WindArrowsPainter old) =>
      old.hourly != hourly;
}

class _SingleHourlyLine extends StatelessWidget {
  final List<IpmaHourly> hourly;
  final double? Function(IpmaHourly) valueOf;
  final String label;
  final Color color;

  const _SingleHourlyLine({
    required this.hourly,
    required this.valueOf,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final pts = <_TimePoint>[];
    for (final h in hourly) {
      final v = valueOf(h);
      if (v != null) pts.add(_TimePoint(h.t, v));
    }
    return charts.TimeSeriesChart(
      [
        charts.Series<_TimePoint, DateTime>(
          id: label,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(color),
          domainFn: (p, _) => p.t,
          measureFn: (p, _) => p.v,
          data: pts,
        ),
      ],
      animate: false,
    );
  }
}

class _PrecipBars extends StatelessWidget {
  final List<IpmaHourly> hourly;
  const _PrecipBars({required this.hourly});

  @override
  Widget build(BuildContext context) {
    final pts = <_TimePoint>[];
    for (final h in hourly) {
      if (h.precipitation != null) {
        pts.add(_TimePoint(h.t, h.precipitation!));
      }
    }
    return charts.TimeSeriesChart(
      [
        charts.Series<_TimePoint, DateTime>(
          id: 'Precipitação (mm)',
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.blue),
          domainFn: (p, _) => p.t,
          measureFn: (p, _) => p.v,
          data: pts,
        ),
      ],
      animate: false,
      defaultRenderer: charts.BarRendererConfig<DateTime>(),
      defaultInteractions: false,
    );
  }
}

class _DailySeriesSpec {
  final String label;
  final Color color;
  final List<IpmaDailyValue>? data;
  _DailySeriesSpec({
    required this.label,
    required this.color,
    required this.data,
  });
}

class _MultiDailyLine extends StatelessWidget {
  final List<_DailySeriesSpec> series;
  const _MultiDailyLine({required this.series});

  @override
  Widget build(BuildContext context) {
    final out = <charts.Series<_TimePoint, DateTime>>[];
    for (final s in series) {
      final raw = s.data;
      if (raw == null) continue;
      final pts = <_TimePoint>[];
      for (final v in raw) {
        if (v.value != null) pts.add(_TimePoint(v.t, v.value!));
      }
      if (pts.isEmpty) continue;
      out.add(charts.Series<_TimePoint, DateTime>(
        id: s.label,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(s.color),
        domainFn: (p, _) => p.t,
        measureFn: (p, _) => p.v,
        data: pts,
      ));
    }
    if (out.isEmpty) {
      return const Center(
        child: Text('Sem dados disponíveis',
            style: TextStyle(fontSize: 12, color: Colors.black45)),
      );
    }
    return charts.TimeSeriesChart(
      out,
      animate: false,
      behaviors: [
        charts.SeriesLegend(
          position: charts.BehaviorPosition.bottom,
          horizontalFirst: true,
          cellPadding: const EdgeInsets.only(right: 12, bottom: 4),
        ),
      ],
    );
  }
}

class _TimePoint {
  final DateTime t;
  final double v;
  _TimePoint(this.t, this.v);
}
