import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:fogosmobile/screens/ar_view/ar_compass_math.dart';

const double _bH = 25.0; // horizontal magnetic component (Portugal, μT)
const double _bV = 35.0; // vertical (downward positive) magnetic component
const double _g = 9.81;

/// Synthesises what a stationary phone would read from its accelerometer and
/// magnetometer at pose ([headingDeg], [pitchDeg], [rollDeg]).
///
/// Heading is clockwise from world-north (0 = camera facing north, 90 = east).
/// Pitch is positive when the camera aims up. Roll rotates the phone around
/// the camera axis.
({List<double> accel, List<double> mag}) _sensorsFor({
  required double headingDeg,
  required double pitchDeg,
  double rollDeg = 0,
}) {
  final h = headingDeg * pi / 180;
  final p = pitchDeg * pi / 180;
  final r = rollDeg * pi / 180;

  // Device axes in world coords after heading + pitch, before roll.
  // Base pose (H=P=R=0): X_dev=east, Y_dev=up, Z_dev=south.
  final xBase = [cos(h), -sin(h), 0.0];
  final yBase = [-sin(p) * sin(h), -sin(p) * cos(h), cos(p)];
  final zBase = [-cos(p) * sin(h), -cos(p) * cos(h), -sin(p)];

  final cR = cos(r), sR = sin(r);
  final xDev = List<double>.generate(
      3, (i) => cR * xBase[i] + sR * yBase[i]);
  final yDev = List<double>.generate(
      3, (i) => -sR * xBase[i] + cR * yBase[i]);
  final zDev = zBase;

  double dot(List<double> a, List<double> b) =>
      a[0] * b[0] + a[1] * b[1] + a[2] * b[2];

  final worldUp = [0.0, 0.0, 1.0];
  final accel = [
    _g * dot(xDev, worldUp),
    _g * dot(yDev, worldUp),
    _g * dot(zDev, worldUp),
  ];

  final magWorld = [0.0, _bH, -_bV];
  final mag = [
    dot(xDev, magWorld),
    dot(yDev, magWorld),
    dot(zDev, magWorld),
  ];

  return (accel: accel, mag: mag);
}

double _angDiff(double a, double b) {
  var d = a - b;
  while (d > 180) d -= 360;
  while (d < -180) d += 360;
  return d.abs();
}

void main() {
  group('computeHeadingTiltCompensated', () {
    test('portrait facing every cardinal returns the true heading', () {
      for (final h in [0.0, 45.0, 90.0, 135.0, 180.0, 225.0, 270.0, 315.0]) {
        final s = _sensorsFor(headingDeg: h, pitchDeg: 0);
        final az = computeHeadingTiltCompensated(s.accel, s.mag);
        expect(_angDiff(az, h), lessThan(0.5),
            reason: 'portrait H=$h returned $az');
      }
    });

    test('handles pitch from -30° to +45° without drift', () {
      for (final h in [0.0, 45.0, 90.0, 180.0, 270.0]) {
        for (final p in [-30.0, -15.0, 0.0, 15.0, 30.0, 45.0]) {
          final s = _sensorsFor(headingDeg: h, pitchDeg: p);
          final az = computeHeadingTiltCompensated(s.accel, s.mag);
          expect(_angDiff(az, h), lessThan(1.0),
              reason: 'H=$h P=$p returned $az');
        }
      }
    });

    test('landscape orientations return the same heading', () {
      for (final h in [0.0, 45.0, 90.0, 180.0]) {
        for (final r in [-90.0, -45.0, 45.0, 90.0]) {
          final s = _sensorsFor(headingDeg: h, pitchDeg: 0, rollDeg: r);
          final az = computeHeadingTiltCompensated(s.accel, s.mag);
          expect(_angDiff(az, h), lessThan(0.5),
              reason: 'H=$h R=$r returned $az');
        }
      }
    });

    test('combined pitch and roll still tracks heading', () {
      final s = _sensorsFor(headingDeg: 135, pitchDeg: 20, rollDeg: 45);
      final az = computeHeadingTiltCompensated(s.accel, s.mag);
      expect(_angDiff(az, 135), lessThan(1.0));
    });

    test('returns NaN when accel is zero', () {
      final az = computeHeadingTiltCompensated([0, 0, 0], [1, 0, 0]);
      expect(az.isNaN, isTrue);
    });

    test('returns NaN when mag is zero', () {
      final az = computeHeadingTiltCompensated([0, 9.81, 0], [0, 0, 0]);
      expect(az.isNaN, isTrue);
    });
  });

  group('computeHeadingAndPitch (nz fix)', () {
    test('portrait facing NE with 30° pitch returns 45° azimuth', () {
      final s = _sensorsFor(headingDeg: 45, pitchDeg: 30);
      final (az, _) = computeHeadingAndPitch(s.accel, s.mag);
      expect(_angDiff(az, 45), lessThan(1.0));
    });

    test('reports pitch matching the simulated pose', () {
      final s = _sensorsFor(headingDeg: 0, pitchDeg: 30);
      final (_, pitch) = computeHeadingAndPitch(s.accel, s.mag);
      expect((pitch - 30).abs(), lessThan(0.5));
    });
  });

  group('computeHeadingRollCompensated', () {
    test('correct at zero pitch (baseline)', () {
      final s = _sensorsFor(headingDeg: 45, pitchDeg: 0);
      final az = computeHeadingRollCompensated(s.accel, s.mag);
      expect(_angDiff(az, 45), lessThan(0.5));
    });

    test('regression evidence: drifts badly when pitched', () {
      // Documents why the incident camera migrated away from this formula.
      // At H=45°, P=30° in Portugal-like magnetic dip, it lands near 97°.
      // If this test ever starts passing under 30° error, the formula was
      // silently changed and callers should be re-evaluated.
      final s = _sensorsFor(headingDeg: 45, pitchDeg: 30);
      final az = computeHeadingRollCompensated(s.accel, s.mag);
      expect(_angDiff(az, 45), greaterThan(30),
          reason: 'unexpectedly close to truth: $az');
    });
  });

  group('magneticFieldMagnitude', () {
    test('3-4-0 vector has magnitude 5', () {
      expect(magneticFieldMagnitude([3, 4, 0]), closeTo(5, 1e-9));
    });

    test('typical Portugal field lands inside plausibility window', () {
      final s = _sensorsFor(headingDeg: 0, pitchDeg: 0);
      final m = magneticFieldMagnitude(s.mag);
      expect(m, inInclusiveRange(20, 75));
    });
  });

  group('bearingTo', () {
    test('north neighbour returns 0°', () {
      expect(bearingTo(0, 0, 1, 0), closeTo(0, 0.1));
    });

    test('east neighbour returns 90°', () {
      expect(bearingTo(0, 0, 0, 1), closeTo(90, 0.1));
    });

    test('south neighbour returns 180°', () {
      expect(bearingTo(0, 0, -1, 0), closeTo(180, 0.1));
    });
  });
}
