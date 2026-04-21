import 'dart:math';

/// Returns bearing in degrees [0, 360) from (lat1,lng1) to (lat2,lng2).
double bearingTo(double lat1, double lng1, double lat2, double lng2) {
  final lat1R = lat1 * pi / 180;
  final lat2R = lat2 * pi / 180;
  final dLngR = (lng2 - lng1) * pi / 180;
  final y = sin(dLngR) * cos(lat2R);
  final x = cos(lat1R) * sin(lat2R) - sin(lat1R) * cos(lat2R) * cos(dLngR);
  return (atan2(y, x) * 180 / pi + 360) % 360;
}

/// Computes azimuth (compass heading) and pitch from raw sensor vectors.
/// [accel] = [ax, ay, az], [mag] = [mx, my, mz]
/// Returns (azimuthDeg, pitchDeg).
(double azimuth, double pitch) computeHeadingAndPitch(
    List<double> accel, List<double> mag) {
  final norm =
      sqrt(accel[0] * accel[0] + accel[1] * accel[1] + accel[2] * accel[2]);
  if (norm == 0) return (0, 0);
  final ax = accel[0] / norm, ay = accel[1] / norm, az = accel[2] / norm;

  final ex = mag[1] * az - mag[2] * ay;
  final ey = mag[2] * ax - mag[0] * az;
  final ez = mag[0] * ay - mag[1] * ax;
  final enorm = sqrt(ex * ex + ey * ey + ez * ez);
  if (enorm == 0) return (0, 0);

  // nz = third component of (g × E) — needed for the camera-direction azimuth.
  final nz = ax * ez / enorm - az * ex / enorm;

  // Camera (back lens) points along -Z in device frame. The correct azimuth for
  // the camera direction is atan2(E·(-Z), N·(-Z)) = atan2(-Ez, -Nz).
  // Using the X-component atan2(ex, nx) was correct only for a flat phone where
  // the camera faces down; for portrait/upright AR it was systematically off.
  final azimuthRad = atan2(-ez / enorm, -nz);
  final azimuthDeg = (azimuthRad * 180 / pi + 360) % 360;
  // Pitch: az≈0 when upright (camera at horizon). Tilting back (camera up)
  // makes az positive → pitch negative → fires shift toward top of screen.
  final pitchDeg = asin(-az) * 180 / pi;
  return (azimuthDeg, pitchDeg);
}

/// Simplified azimuth for a phone held perfectly upright (portrait).
/// Camera points along -Z device axis → azimuth = atan2(-mx, -mz).
/// Avoids tilt-compensation errors when pitch is assumed to be ~0.
double computeHeadingVertical(List<double> mag) {
  final azimuthRad = atan2(-mag[0], -mag[2]);
  return (azimuthRad * 180 / pi + 360) % 360;
}

/// Returns pixel X for a fire given its relative bearing to device heading.
/// Returns null when outside the ±fovDeg/2 cone.
double? projectToScreenX(double relBearing, double screenWidth,
    {double fovDeg = 60.0}) {
  double r = ((relBearing + 180) % 360) - 180;
  if (r.abs() > fovDeg / 2) return null;
  return (r / fovDeg + 0.5) * screenWidth;
}

/// Returns pixel Y position based on camera elevation angle (degrees).
/// pitch = 0°  → camera at horizon → center of screen.
/// pitch > 0°  → camera looking up  → fires at horizon shift down.
/// pitch < 0°  → camera looking down → fires at horizon shift up.
double projectToScreenY(double devicePitch, double screenHeight,
    {double fovVertDeg = 60.0}) {
  final clamped = devicePitch.clamp(-fovVertDeg / 2, fovVertDeg / 2);
  return (clamped / fovVertDeg + 0.5) * screenHeight;
}
