import 'dart:convert';
import 'dart:typed_data';

/// Iberian-domain u/v wind grid served by `https://fogos.pt/v1/ipma-wind`.
/// Two GRIB-style records: index 0 = U (east-west), index 1 = V (north-south).
class IpmaWindGrid {
  final int nx;
  final int ny;
  final double lo1;
  final double lo2;
  final double la1;
  final double la2;
  final double dx;
  final double dy;
  final Float32List u;
  final Float32List v;

  IpmaWindGrid({
    required this.nx,
    required this.ny,
    required this.lo1,
    required this.lo2,
    required this.la1,
    required this.la2,
    required this.dx,
    required this.dy,
    required this.u,
    required this.v,
  });
}

/// Top-level so it can run inside `compute()`. The body is the raw JSON string
/// returned by `/v1/ipma-wind` (~370 KB; parsing it on the main isolate would
/// stall ~100 ms on a mid-range device).
IpmaWindGrid? parseIpmaWindGrid(String body) {
  final decoded = jsonDecode(body);
  if (decoded is! List || decoded.length < 2) return null;
  final uRec = decoded[0] as Map<String, dynamic>;
  final vRec = decoded[1] as Map<String, dynamic>;
  final h = uRec['header'] as Map<String, dynamic>;

  final uList = (uRec['data'] as List).cast<num>();
  final vList = (vRec['data'] as List).cast<num>();
  final u = Float32List(uList.length);
  final v = Float32List(vList.length);
  for (var i = 0; i < uList.length; i++) u[i] = uList[i].toDouble();
  for (var i = 0; i < vList.length; i++) v[i] = vList[i].toDouble();

  return IpmaWindGrid(
    nx: (h['nx'] as num).toInt(),
    ny: (h['ny'] as num).toInt(),
    lo1: (h['lo1'] as num).toDouble(),
    lo2: (h['lo2'] as num).toDouble(),
    la1: (h['la1'] as num).toDouble(),
    la2: (h['la2'] as num).toDouble(),
    dx: (h['dx'] as num).toDouble(),
    dy: (h['dy'] as num).toDouble(),
    u: u,
    v: v,
  );
}
