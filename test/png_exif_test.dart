import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:fogosmobile/utils/png_exif.dart';

// Minimal 1x1 transparent PNG (signature + IHDR + IDAT + IEND).
final Uint8List _minimalPng = Uint8List.fromList([
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
  // IHDR: length=13, type, 1x1 RGBA
  0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
  0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89,
  // IDAT: length=12, deflate of one transparent pixel
  0x00, 0x00, 0x00, 0x0C, 0x49, 0x44, 0x41, 0x54,
  0x08, 0x99, 0x63, 0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01,
  0x0D, 0x0A, 0x2D, 0xB4,
  // IEND
  0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
]);

void main() {
  test('addPngExif inserts an eXIf chunk before IDAT', () {
    final out = addPngExif(
      pngBytes: _minimalPng,
      lat: 41.1496,
      lng: -8.6109,
      altitude: 87.5,
      imgDirection: 215.0,
      dateTimeOriginal: DateTime.utc(2026, 5, 7, 14, 30, 12),
    );
    expect(out.length, greaterThan(_minimalPng.length));

    // PNG signature preserved.
    expect(out.sublist(0, 8), _minimalPng.sublist(0, 8));

    // Find eXIf chunk type bytes ('e','X','I','f' = 0x65,0x58,0x49,0x66).
    var found = false;
    var exifStart = -1;
    for (var i = 8; i < out.length - 4; i++) {
      if (out[i] == 0x65 && out[i + 1] == 0x58 && out[i + 2] == 0x49 && out[i + 3] == 0x66) {
        found = true;
        exifStart = i + 4; // start of TIFF data
        break;
      }
    }
    expect(found, isTrue);

    // TIFF header: II (little endian) + magic 0x002A
    expect(out[exifStart], 0x49);
    expect(out[exifStart + 1], 0x49);
    expect(out[exifStart + 2], 0x2A);
    expect(out[exifStart + 3], 0x00);

    // GPS tags (0x0001 GPSLatitudeRef, 0x0002 GPSLatitude, 0x0004 GPSLongitude,
    // 0x0006 GPSAltitude, 0x0011 GPSImgDirection) should appear in the bytes.
    bool containsTag(int tag) {
      final lo = tag & 0xFF, hi = (tag >> 8) & 0xFF;
      for (var i = exifStart; i < out.length - 1; i++) {
        if (out[i] == lo && out[i + 1] == hi) return true;
      }
      return false;
    }
    expect(containsTag(0x0001), isTrue, reason: 'GPSLatitudeRef');
    expect(containsTag(0x0002), isTrue, reason: 'GPSLatitude');
    expect(containsTag(0x0004), isTrue, reason: 'GPSLongitude');
    expect(containsTag(0x0006), isTrue, reason: 'GPSAltitude');
    expect(containsTag(0x0011), isTrue, reason: 'GPSImgDirection');
  });

  test('addPngExif preserves the IEND chunk at the end', () {
    final out = addPngExif(
      pngBytes: _minimalPng,
      lat: 0.0,
      lng: 0.0,
      altitude: 0.0,
      imgDirection: 0.0,
      dateTimeOriginal: DateTime.utc(2026, 1, 1),
    );
    final tail = out.sublist(out.length - 12);
    expect(tail.sublist(4, 8), [0x49, 0x45, 0x4E, 0x44]); // 'IEND'
  });
}
