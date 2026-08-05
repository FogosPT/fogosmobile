const String ipmaWmsBase = 'https://fogos.pt/v1/ipma-wms';

class IpmaLayerGroup {
  final String key;
  final String label;
  final List<String> wmsLayerNames;
  final double opacity;
  final bool isWindBarbs;
  final bool requiresReferenceTime;

  const IpmaLayerGroup({
    required this.key,
    required this.label,
    required this.wmsLayerNames,
    this.opacity = 0.6,
    this.isWindBarbs = false,
    this.requiresReferenceTime = true,
  });

  String get legendLayerName => wmsLayerNames.first;
}

const List<IpmaLayerGroup> ipmaAromeGroups = [
  IpmaLayerGroup(
    key: 'ipma-temperature',
    label: 'Temperatura',
    wmsLayerNames: [
      'arome.2m.temperature.continent',
      'arome.2m.temperature.madeira',
      'arome.2m.temperature.azores',
    ],
  ),
  IpmaLayerGroup(
    key: 'ipma-wind',
    label: 'Vento',
    wmsLayerNames: [
      'arome.10m.windintensity.continent',
      'arome.10m.windintensity.madeira',
      'arome.10m.windintensity.azores',
    ],
  ),
  IpmaLayerGroup(
    key: 'ipma-wind-direction',
    label: 'Direção do vento',
    wmsLayerNames: [
      'arome.10m.windbarbs.continent',
      'arome.10m.windbarbs.madeira',
      'arome.10m.windbarbs.azores',
    ],
    opacity: 1.0,
    isWindBarbs: true,
  ),
  IpmaLayerGroup(
    key: 'ipma-precipitation',
    label: 'Precipitação',
    wmsLayerNames: [
      'arome.0m.precipitation.continent',
      'arome.0m.precipitation.madeira',
      'arome.0m.precipitation.azores',
    ],
  ),
  IpmaLayerGroup(
    key: 'ipma-humidity',
    label: 'Humidade',
    wmsLayerNames: [
      'arome.2m.relative_humidity.continent',
      'arome.2m.relative_humidity.madeira',
      'arome.2m.relative_humidity.azores',
    ],
  ),
];

const IpmaLayerGroup ipmaFrpGroup = IpmaLayerGroup(
  key: 'ipma-frp',
  label: 'IPMA FRP',
  wmsLayerNames: ['lsasaf.frp.continent'],
  requiresReferenceTime: false,
);

const List<IpmaLayerGroup> ipmaAllGroups = [
  ...ipmaAromeGroups,
  ipmaFrpGroup,
];

IpmaLayerGroup? ipmaGroupForKey(String key) {
  for (final g in ipmaAllGroups) {
    if (g.key == key) return g;
  }
  return null;
}

String ipmaTileUrl(String wmsLayer, {String? referenceTime}) {
  final base = '$ipmaWmsBase?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetMap'
      '&LAYERS=$wmsLayer&STYLES=&CRS=EPSG:3857'
      '&BBOX={bbox-epsg-3857}&WIDTH=256&HEIGHT=256'
      '&FORMAT=image/png&TRANSPARENT=true';
  if (referenceTime == null || referenceTime.isEmpty) return base;
  return '$base&reference_time=${Uri.encodeQueryComponent(referenceTime)}';
}

String ipmaLegendUrl(String wmsLayer) =>
    '${ipmaWmsBase}?version=1.3.0&service=WMS&request=GetLegendGraphic'
    '&sld_version=1.1.0&layer=$wmsLayer'
    '&format=image/png&STYLE=default';
