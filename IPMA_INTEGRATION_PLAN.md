# IPMA WMS Layers — Flutter Implementation Brief

> Handoff doc for porting the IPMA forecast/satellite overlays from fogos.pt
> (web, Leaflet) to fogosmobile (Flutter, `mapbox_maps_flutter ^2.6.0`).

## 1. Context & goal

The fogos.pt web app now exposes IPMA's high-resolution forecast model (AROME, modelo nacional) plus the LSA-SAF Fire Radiative Power product as toggleable overlays on the main map. This document describes the WMS service, the exact layer names, the legend system, and how to translate the Leaflet-based implementation to a `mapbox_maps_flutter` raster-source approach on mobile.

**Why this matters**: AROME covers Portugal continente + Madeira + Açores with much higher spatial resolution and PT-specific calibration than the global OpenWeatherMap data currently shown in the app, and the IPMA legends are colour-calibrated for the local climate. FRP (satellite-detected heat) complements MODIS/VIIRS and refreshes every 15 minutes.

**End-state in the mobile app**: in the existing layers panel (entry point `lib/screens/widgets/map_layers_button.dart`), add a new "Previsão IPMA" group with five toggles (temperatura, vento intensidade, direcção do vento, precipitação, humidade) plus an "IPMA FRP" toggle next to MODIS/VIIRS. While any IPMA layer is active, a floating legend should render the official IPMA colour scale.

---

## 2. The IPMA WMS endpoint

```
https://mf2.ipma.pt/services/
```

| Property | Value |
|---|---|
| Protocol | WMS 1.3.0 (OGC) |
| TLS | HTTPS available, valid certificate |
| CORS | `Access-Control-Allow-Origin: *` (irrelevant on mobile but confirms public access) |
| Auth | None — fully public, no key, no rate limit documented |
| Capabilities | `https://mf2.ipma.pt/services/?SERVICE=WMS&REQUEST=GetCapabilities` |
| Supported CRS | Includes `EPSG:3857` (Web Mercator) and `EPSG:4326` — use **3857** for Mapbox |
| Tile format | `image/png` with `TRANSPARENT=true` |
| Refresh cadence | AROME runs 2× daily (00 & 12 UTC); FRP every 15 min |
| Default `TIME` | Server returns the current model run if `TIME=` is omitted |
| Attribution | "Previsão © IPMA (modelo AROME)" — required |
| Licensing | Portuguese government open data (Lei 26/2016); free public reuse with attribution. LSA-SAF products are CC-BY-4.0 via EUMETSAT |

---

## 3. Layer catalog

All layers below are confirmed present in `GetCapabilities`. Each AROME product has three regional variants — toggle them together as a group; the bounding boxes don't overlap so requesting all three is cheap.

### 3.1 AROME forecast layers (national meteorological model)

| Section item | Continente | Madeira | Açores | Notes |
|---|---|---|---|---|
| Temperatura (2 m) | `arome.2m.temperature.continent` | `arome.2m.temperature.madeira` | `arome.2m.temperature.azores` | Colour-fill, ≈ –10 °C to 45 °C |
| Vento — intensidade (10 m) | `arome.10m.windintensity.continent` | `arome.10m.windintensity.madeira` | `arome.10m.windintensity.azores` | Colour-fill speed contours |
| Direcção do vento (10 m) | `arome.10m.windbarbs.continent` | `arome.10m.windbarbs.madeira` | `arome.10m.windbarbs.azores` | Sparse barbs; needs visual boost (see §6) |
| Precipitação (0 m) | `arome.0m.precipitation.continent` | `arome.0m.precipitation.madeira` | `arome.0m.precipitation.azores` | Accumulated forecast precip |
| Humidade relativa (2 m) | `arome.2m.relative_humidity.continent` | `arome.2m.relative_humidity.madeira` | `arome.2m.relative_humidity.azores` | Percent |

Optional extras available if useful later: `arome.10m.gustintensity.*`, `arome.2m.dewpoint.*`, `arome.2m.pressure.*`.

### 3.2 LSA-SAF satellite layers (add to existing satellite section)

| Section item | Layer name | Notes |
|---|---|---|
| IPMA FRP | `lsasaf.frp.continent` | Fire Radiative Power, 15-min refresh, satellite-detected active fires |
| (Optional) Fire Weather Index | `lsasaf.fwi.continent` | Daily FWI index |

---

## 4. WMS → Mapbox in Flutter

`mapbox_maps_flutter` does **not** speak WMS natively, but a WMS `GetMap` request can be wrapped as a `RasterSource` whose `tiles` URL template uses Mapbox's built-in placeholder `{bbox-epsg-3857}`. Mapbox substitutes the correct EPSG:3857 bounding box for each tile request at runtime, so each tile becomes a valid WMS `GetMap` call.

### 4.1 URL template

```
https://mf2.ipma.pt/services/?SERVICE=WMS
  &VERSION=1.3.0
  &REQUEST=GetMap
  &LAYERS={LAYER_NAME}
  &STYLES=
  &CRS=EPSG:3857
  &BBOX={bbox-epsg-3857}
  &WIDTH=256
  &HEIGHT=256
  &FORMAT=image/png
  &TRANSPARENT=true
```

(Concatenate without newlines.) Note `CRS=EPSG:3857` (WMS 1.3.0 uses `CRS=`, not `SRS=`).

### 4.2 Adding a raster layer in Dart

Sketch (adapt to the project's style — see `fogos_map.dart` for the existing `MapboxMap` setup and how it currently adds sources/layers):

```dart
Future<void> addIpmaLayer({
  required MapboxMap map,
  required String sourceId,           // e.g. "ipma-temp-continent"
  required String wmsLayerName,       // e.g. "arome.2m.temperature.continent"
  double opacity = 0.6,
}) async {
  final url =
      'https://mf2.ipma.pt/services/?SERVICE=WMS&VERSION=1.3.0'
      '&REQUEST=GetMap&LAYERS=$wmsLayerName&STYLES='
      '&CRS=EPSG:3857&BBOX={bbox-epsg-3857}'
      '&WIDTH=256&HEIGHT=256&FORMAT=image/png&TRANSPARENT=true';

  await map.style.addSource(RasterSource(
    id: sourceId,
    tiles: [url],
    tileSize: 256,
  ));

  await map.style.addLayer(RasterLayer(
    id: '$sourceId-layer',
    sourceId: sourceId,
    rasterOpacity: opacity,
  ));
}
```

### 4.3 Grouping continent / Madeira / Açores

In Leaflet we wrap the three regional variants in a `L.layerGroup`. On Mapbox, each variant must be a separate `RasterSource` + `RasterLayer` — but their toggle state is shared. Suggested abstraction:

```dart
class IpmaLayerGroup {
  final String key;                       // 'ipma-temperature'
  final String label;                     // 'Temperatura'
  final List<String> wmsLayerNames;       // 3 layer names
  final double opacity;
  final String? rasterClassName;          // for special styling (windbarbs)

  bool _added = false;

  Future<void> add(MapboxMap map) async {
    for (var i = 0; i < wmsLayerNames.length; i++) {
      await addIpmaLayer(
        map: map,
        sourceId: '$key-$i',
        wmsLayerName: wmsLayerNames[i],
        opacity: opacity,
      );
    }
    _added = true;
  }

  Future<void> remove(MapboxMap map) async {
    for (var i = 0; i < wmsLayerNames.length; i++) {
      await map.style.removeStyleLayer('$key-$i-layer');
      await map.style.removeStyleSource('$key-$i');
    }
    _added = false;
  }
}
```

### 4.4 Layer ordering on the map

Insert IPMA raster layers **above** the basemap tiles but **below** the fire-marker symbol layers, otherwise the overlays will hide the markers. Mapbox's `addLayer` takes an optional `LayerPosition` — pass the marker layer's id as `below`.

---

## 5. Legends (`GetLegendGraphic`)

WMS provides a separate request for the colour scale. Endpoint shape:

```
https://mf2.ipma.pt/services?version=1.3.0
  &service=WMS
  &request=GetLegendGraphic
  &sld_version=1.1.0
  &layer={LAYER_NAME}
  &format=image/png
  &STYLE=default
```

**Required parameters that surprised me**:
- `STYLE=default` — **must** be present. Without it the server returns HTTP 500.
- `sld_version=1.1.0` — formally requested by the server.

Sample response: PNG, ~124 × 440 px vertical strip with colour swatches and units. The legend is **independent of region** — `arome.2m.temperature.continent` and `.madeira` share the same colour scale, so fetch one legend per logical group (use the `.continent` variant for the URL).

### 5.1 Flutter rendering

Implement a floating widget overlaying the map (bottom-left corner). For each active IPMA layer group, render:

```dart
Column(
  children: [
    Text(group.label, style: const TextStyle(
        fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.3)),
    Image.network(group.legendUrl, height: 220, fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const SizedBox.shrink()),
  ],
)
```

Layout multiple active legends side-by-side in a `Row` inside a translucent `Container` (white at 92% alpha, 6 px radius, light shadow). Hide the whole widget when no IPMA layer is active.

Cache the legend `NetworkImage` (Flutter does this by default) — refreshing is not needed; the scales are static metadata that don't change between model runs.

---

## 6. Wind barbs visual treatment

The IPMA windbarbs PNG ships pale grey/dark grey arrows on a transparent background. At default opacity 0.6 they almost vanish against satellite or busy basemaps. On the web we applied two adjustments:

1. **Opacity 1.0** for this layer only (the other AROME products keep 0.6 because they're colour fills where the basemap should bleed through).
2. **CSS filter** to darken and thicken the rendered tiles:
   ```css
   filter:
     brightness(0.25) contrast(2)
     drop-shadow(0.5px 0 0 #000)
     drop-shadow(-0.5px 0 0 #000)
     drop-shadow(0 0.5px 0 #000)
     drop-shadow(0 -0.5px 0 #000);
   ```

### 6.1 Mapbox / Flutter equivalents

Mapbox raster layers don't expose CSS-level filters. Options, in increasing order of effort:

1. **Easiest, partial fix** — set `rasterContrast: 1.0`, `rasterBrightnessMax: 0.4`, `rasterBrightnessMin: 0.0`, `rasterSaturation: -1.0` on the windbarbs `RasterLayer`. This will darken visibly and remove any colour tint, though it can't thicken the strokes.
2. **Better** — wrap the `MapWidget` in a Flutter `ColorFiltered` widget *only for the moments* when windbarbs is active, applying a `ColorFilter.matrix(...)` that increases contrast. Downside: the filter affects the entire map, not just one layer. Not recommended.
3. **Best** — fetch each tile via a custom image provider that runs the tile bytes through a small Dart/Skia image pipeline (multiply alpha, dilate by 1px). Implementation cost: medium; one-time work. Not necessary if option 1 looks acceptable; treat as a follow-up.

Start with option 1 and reassess after seeing it on device.

---

## 7. Reproducing the web panel UX

For reference, the unified panel on the web exposes these sections, in order:

1. **Mapa base** (radio): Normal (OSM) / Satélite (Esri World Imagery hybrid)
2. **Estado dos fogos** (10 checkboxes mapping to fire status codes)
3. **Perigo de Incêndio Rural** (radio: Hoje / Amanhã / Depois)
4. **Hotspots satélite** (MODIS / VIIRS / **IPMA FRP**)
5. **Meteorologia** (5 OWM tile layers — keep on the web for fallback; the mobile app can skip if IPMA covers the use case)
6. **Previsão IPMA** (5 AROME items as detailed in §3)

The panel persists every toggle and the section/panel collapse state in `localStorage` under the key `fogos:map-panel`. For Flutter, use `SharedPreferences` with a similar key (e.g. `fogos.map_panel_state` → JSON map of `section:item -> bool`).

State precedence on launch: stored value if present, else the defaults in §7.1.

### 7.1 Default on/off state per item

| Section | Item | Default |
|---|---|---|
| Mapa base | Normal | **on** |
| Mapa base | Satélite | off |
| Estado dos fogos | (all 10) | **on** |
| Perigo | (any) | off |
| Hotspots satélite | MODIS / VIIRS / IPMA FRP | off |
| Previsão IPMA | (all 5) | off |

The whole panel starts **collapsed** for first-time users and only stays open after they explicitly open it.

---

## 8. Attribution

IPMA's terms require attributing them on the map UI when the layer is active. On the web Leaflet handles this automatically via `attribution:` on each tile layer. On Mapbox in Flutter you need to render attribution manually — the project already has `mapbox_copyright.dart` doing this for the basemap.

Add to that overlay, conditional on IPMA layers being active:
- AROME layers: `Previsão © IPMA (modelo AROME)` (link `https://www.ipma.pt`)
- LSA-SAF FRP: `Fire Radiative Power © LSA-SAF / IPMA`

---

## 9. Verification checklist

1. Build the app in debug mode, open the map.
2. Open layers panel → confirm new "Previsão IPMA" section is present with five toggles.
3. Activate **Temperatura** → coloured gradient covers continente + Madeira + Açores; legend appears bottom-left with the IPMA colour scale.
4. Activate **Direcção do vento** → arrows are clearly visible (not pale grey). Compare against the IPMA web site (https://mf2.ipma.pt/continent) — direction and density should match.
5. Activate two layers simultaneously → both legends render side-by-side in the floating widget.
6. Toggle each layer off → corresponding legend disappears.
7. Pan and zoom across mainland / Madeira / Azores → tiles redraw smoothly. Open device DevTools / proxy → outgoing requests hit `https://mf2.ipma.pt/services/?SERVICE=WMS&…&REQUEST=GetMap`, status 200, content-type `image/png`.
8. Force-quit and relaunch app → previously toggled IPMA layers are still active (persistence works).
9. Activate **IPMA FRP** alongside MODIS/VIIRS → all three render together as satellite-derived heat layers.
10. Switch device language between PT / EN / ES → section header and item labels translate (i18n strings in §10).

---

## 10. i18n strings to add

Match the labels used in the web app (`resources/lang/{pt,en,es}/js.php`). For each locale file the mobile app uses:

| Key | PT | EN | ES |
|---|---|---|---|
| `panel.ipma` | Previsão IPMA | IPMA forecast | Previsión IPMA |
| `map.temperature` | Temperatura | Temperature | Temperatura |
| `map.wind` | Vento | Wind | Viento |
| `map.windDirection` | Direção do vento | Wind direction | Dirección del viento |
| `map.precipitation` | Precipitação | Precipitation | Precipitación |
| `map.humidity` | Humidade | Humidity | Humedad |

`IPMA FRP` stays as-is in all locales (proper name).

---

## 11. Known limits / non-goals

- **No `TIME` slider yet.** The server returns the current model run by default. AROME runs twice daily, so the data is at most 12 h old. A future enhancement could expose a slider that sends `TIME=2026-05-13T12:00` to step through forecast hours.
- **No precipitation radar.** IPMA does **not** publish radar as WMS — only static PNG galleries at `ipma.pt/otempo/obs.remote`. If real-time radar matters for the mobile app, integrate **RainViewer** (free, public, animated radar — `api.rainviewer.com`) separately. Not in scope here.
- **WMS performance.** Each pan/zoom triggers `GetMap` requests against IPMA. The service is public and uncached at the edge. Recommend keeping IPMA layers default-off (as on web) and showing them only on user opt-in to avoid hammering the upstream.
- **Layer outside Portugal**: tiles outside the AROME bounding box come back empty/transparent. Acceptable because the app is PT-scoped.

---

## 12. Quick reference: copy-paste constants

```dart
const ipmaWmsBase = 'https://mf2.ipma.pt/services/';

const ipmaLayers = {
  'temperature':   ['arome.2m.temperature.continent',       'arome.2m.temperature.madeira',       'arome.2m.temperature.azores'],
  'wind':          ['arome.10m.windintensity.continent',    'arome.10m.windintensity.madeira',    'arome.10m.windintensity.azores'],
  'windDirection': ['arome.10m.windbarbs.continent',        'arome.10m.windbarbs.madeira',        'arome.10m.windbarbs.azores'],
  'precipitation': ['arome.0m.precipitation.continent',     'arome.0m.precipitation.madeira',     'arome.0m.precipitation.azores'],
  'humidity':      ['arome.2m.relative_humidity.continent', 'arome.2m.relative_humidity.madeira', 'arome.2m.relative_humidity.azores'],
};

const ipmaFrpLayer = 'lsasaf.frp.continent';

String ipmaTileUrl(String wmsLayer) =>
  '$ipmaWmsBase?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetMap'
  '&LAYERS=$wmsLayer&STYLES=&CRS=EPSG:3857'
  '&BBOX={bbox-epsg-3857}&WIDTH=256&HEIGHT=256'
  '&FORMAT=image/png&TRANSPARENT=true';

String ipmaLegendUrl(String wmsLayer) =>
  '${ipmaWmsBase}?version=1.3.0&service=WMS&request=GetLegendGraphic'
  '&sld_version=1.1.0&layer=$wmsLayer'
  '&format=image/png&STYLE=default';
```

That's everything the implementing agent needs. The integration points in the existing Flutter code are `lib/screens/widgets/fogos_map.dart` (add raster sources/layers when toggles flip), `lib/screens/widgets/map_layers_button.dart` (add the new section to the panel UI), and any state container under `lib/store/` to persist toggle state across launches.

---

# Addendum (2026-05-14): critical fixes and animated wind

Two new pieces landed on the web app after the original plan was written. Both should be mirrored in the mobile app.

## A. Critical: `reference_time` is mandatory on AROME WMS requests

The original plan said `GetMap` without a `TIME` parameter returns the current run. **That is wrong in practice.** The IPMA WMS advertises a default `reference_time` in its `GetCapabilities` document, but the server actually returns **HTTP 404 for every `GetMap` request that doesn't include `reference_time` explicitly**. To make matters worse, the advertised default (e.g. today at 00:00 UTC) is often not yet produced — IPMA runs AROME twice daily at 00 and 12 UTC, with a ~10–12 h publication lag.

Without this fix every AROME layer in the mobile app will silently return 404 and nothing will render.

### A.1 What the web does

The Laravel backend exposes a tiny endpoint that probes the WMS itself and caches the answer in Redis for 30 min:

```
GET https://fogos.pt/v1/ipma-reference-time
→ { "reference_time": "2026-05-13T12:00" }
```

Logic in PHP (`ApiController::getIpmaReferenceTime`):

1. Start with today at the latest 12-hour boundary in UTC (00 if hour < 12 else 12).
2. Send a `HEAD` to a 32×32 GetMap of `arome.2m.temperature.continent` with `&reference_time={candidate}`.
3. If 200 → cache and return. If 404 → step back 12 h and retry. Cap at 4 candidates.

### A.2 What to do on mobile

**Easiest path: call the fogos.pt API directly** from Dart and reuse the cached answer:

```dart
Future<String?> fetchIpmaReferenceTime() async {
  final r = await http.get(Uri.parse('https://fogos.pt/v1/ipma-reference-time'));
  if (r.statusCode != 200) return null;
  final body = jsonDecode(r.body) as Map<String, dynamic>;
  return body['reference_time'] as String?;
}
```

Run this **once at app startup** (or when the layers panel is first opened) and store the value in app state. It's cheap (< 1 KB, served from Redis), keeps the IPMA probe centralised on fogos.pt, and means the mobile app benefits from the same caching that protects IPMA from being hammered.

### A.3 Wire it into the tile URL

Update the `ipmaTileUrl` helper from the original plan to require a `referenceTime`:

```dart
String ipmaTileUrl(String wmsLayer, String referenceTime) =>
  '$ipmaWmsBase?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetMap'
  '&LAYERS=$wmsLayer&STYLES=&CRS=EPSG:3857'
  '&BBOX={bbox-epsg-3857}&WIDTH=256&HEIGHT=256'
  '&FORMAT=image/png&TRANSPARENT=true'
  '&reference_time=${Uri.encodeQueryComponent(referenceTime)}';
```

### A.4 Ordering: do not add the IPMA raster sources before the ref-time is known

Mapbox raster sources can't be retrofitted with a new URL after creation, so:

1. Block the registration of AROME `RasterSource`s on `fetchIpmaReferenceTime()` resolving.
2. If the user toggles an IPMA layer before that future resolves, show a brief loading state on the toggle (a spinner or simply a disabled state) and add the source once the future returns.
3. The LSA-SAF FRP layer (`lsasaf.frp.continent`) **does not need `reference_time`** — register it normally without waiting.

### A.5 Behaviour if the probe fails

If `/v1/ipma-reference-time` returns 503 or times out, keep the IPMA section visible but disabled. The legends are still served by IPMA without ref-time (the `GetLegendGraphic` endpoint isn't affected by this bug).

---

## B. New feature: animated wind streamlines

In parallel with the static `windbarbs` overlay (already covered in §3 and §6 of the original plan), the web app gained a second wind option called **Vento animado / Animated wind**: a particle-flow visualisation rendered from the AROME 10 m u/v wind grid, comparable to what `windy.com` or `earth.nullschool.net` show.

The two stay as separate toggles in the panel — they answer different questions (snapshot of barbs at a moment vs. continuous flow animation) and users with slow phones or low data plans may prefer the cheaper barbs.

### B.1 Backend (already running on fogos.pt)

```
GET https://fogos.pt/v1/ipma-wind
```

Returns a ~370 KB JSON in the leaflet-velocity / earth.nullschool format:

```json
[
  { "header": { "nx": 174, "ny": 162, "numberPoints": 28188,
                "lo1": -12.79, "lo2": -1.26, "la1": 44.79, "la2": 34.06,
                "dx": 0.067, "dy": 0.067,
                "parameterCategory": 2, "parameterNumber": 2,
                "parameterUnit": "m.s-1",
                "refTime": "2026-05-13T12:00Z", "forecastTime": 20 },
    "data": [u₀, u₁, …, u₂₈₁₈₇] },
  { "header": { /* same grid */
                "parameterCategory": 2, "parameterNumber": 3,
                "parameterUnit": "m.s-1" },
    "data": [v₀, v₁, …, v₂₈₁₈₇] }
]
```

- Grid: **174 × 162 cells, ~0.067° spacing, covering Iberia (−12.79°W to −1.26°E, 34.06°N to 44.79°N)**.
- Item 0 is the **U** (east-west) component, item 1 is **V** (north-south). Wind direction = `atan2(v, u)`, speed = `sqrt(u² + v²)`, both in m/s.
- Cached in Redis for 30 min on the server. Mobile app can re-use the same `http` cache or a custom file cache without worrying about overloading IPMA.

### B.2 What the web does (for reference)

Loads the `leaflet-velocity` plugin and feeds it the JSON. The plugin renders a Canvas2D overlay that traces particles along the wind field with a fade-out trail.

### B.3 Flutter implementation — recommended approach

There is no Flutter port of `leaflet-velocity` and `mapbox_maps_flutter` doesn't expose a particle/raster layer that would render this natively. Three options, in increasing effort but increasing fidelity:

**Option 1 — skip the animation (recommended for first iteration).** Ship only the static `windbarbs` overlay from the original plan. The animated layer is a nice-to-have on mobile where battery and data are constrained. Defer until the rest of the panel is stable.

**Option 2 — Flutter `CustomPainter` overlay (medium effort).** Stack a transparent `CustomPaint` widget on top of the `MapWidget`, listen to the Mapbox camera stream, and draw the particle system in Dart:

```
┌──────────────────────────────────┐
│  Stack                           │
│    ├─ MapWidget (Mapbox)         │
│    └─ IgnorePointer              │
│         └─ CustomPaint           │
│              painter: WindFlow…  │
└──────────────────────────────────┘
```

Sketch of the particle loop:
- Maintain N particles (e.g. 800) with random (lat, lng) inside the AROME grid bbox.
- Each frame:
  1. For each particle, bilinear-interpolate u/v at (lat, lng) from the grid.
  2. Advance lat += v * Δt, lng += u * Δt (with appropriate scaling — wind speed at 10 m is ~5–15 m/s; particles should cross the screen in a few seconds, so empirical scaling of `Δt ≈ 0.0003` works on screen-sized maps).
  3. After M steps (e.g. 60), respawn particle at random.
  4. Translate each particle's lat/lng to screen pixels using the Mapbox camera matrix (use `MapboxMap.pixelForCoordinate`).
- Draw very short line segments from previous to current screen position with low-alpha white, accumulating on a backbuffer canvas to produce trails (or just redraw with `Canvas.drawLine` and accept slightly blockier visuals).

The `mapbox_maps_flutter` API exposes `pixelForCoordinate(Point)` which returns the screen pixel for a geographic coordinate. Use it sparingly (batched per frame) — it's a platform-channel call. For performance, consider doing the projection in Dart using Web Mercator math and the current camera state to avoid the round-trip.

**Option 3 — embed `leaflet-velocity` in a `webview_flutter` overlay (high effort, not recommended).** Heavy, breaks gestures, drains battery. Mention only as a fallback if option 2 proves too slow.

### B.4 Performance budget for option 2

On a mid-range phone with 60 fps target:
- 800 particles × 16 ms frame budget = ~20 µs per particle.
- Bilinear interpolation on a 174×162 grid kept in a `Float32List` is well within budget.
- The platform-channel `pixelForCoordinate` is the bottleneck — if you call it 800× per frame you'll drop to 30 fps. Mitigation: project lat/lng → screen pixels in Dart using `WebMercatorProjector(zoom, center, viewportSize)` (~20 lines of math). Only call `pixelForCoordinate` once per second to recalibrate against any Mapbox projection drift.

### B.5 UX details to mirror from the web

- Caption / readout: when the user taps a point on the map while the layer is on, show "X m/s, ENE" (speed + cardinal direction). The web uses a corner overlay; mobile can use a tap-to-reveal or always-on speed scale near the existing legend area.
- Colour ramp: white particles work well over both light and satellite basemaps. Keep `lineWidth ≈ 1.5`, `particleAge ≈ 60` frames.
- When toggled off, dispose the painter and stop the ticker — no background CPU.

### B.6 i18n strings to add

| Key | PT | EN | ES |
|---|---|---|---|
| `map.windAnimated` | Vento animado | Animated wind | Viento animado |

(Goes alongside the `map.windDirection` row in the table from §10 of the original plan.)

---

## C. Updated quick reference

```dart
const fogosApiBase = 'https://fogos.pt';

// Critical: AROME tiles require this. FRP and LegendGraphic don't.
Future<String?> ipmaReferenceTime() async {
  final r = await http.get(Uri.parse('$fogosApiBase/v1/ipma-reference-time'));
  return r.statusCode == 200
      ? (jsonDecode(r.body) as Map)['reference_time'] as String?
      : null;
}

// u/v wind grid for the optional animated layer (option 2 in §B.3)
Future<List<dynamic>?> ipmaWindGrid() async {
  final r = await http.get(Uri.parse('$fogosApiBase/v1/ipma-wind'));
  return r.statusCode == 200 ? jsonDecode(r.body) as List<dynamic> : null;
}

String ipmaTileUrl(String wmsLayer, String referenceTime) =>
  'https://mf2.ipma.pt/services/?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetMap'
  '&LAYERS=$wmsLayer&STYLES=&CRS=EPSG:3857'
  '&BBOX={bbox-epsg-3857}&WIDTH=256&HEIGHT=256'
  '&FORMAT=image/png&TRANSPARENT=true'
  '&reference_time=${Uri.encodeQueryComponent(referenceTime)}';

// FRP keeps the original (no reference_time) helper from the first version.
String ipmaFrpTileUrl(String wmsLayer) =>
  'https://mf2.ipma.pt/services/?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetMap'
  '&LAYERS=$wmsLayer&STYLES=&CRS=EPSG:3857'
  '&BBOX={bbox-epsg-3857}&WIDTH=256&HEIGHT=256'
  '&FORMAT=image/png&TRANSPARENT=true';
```

---

## D. Updated verification checklist

Replace the old §9 with this combined check:

1. App launch: `GET /v1/ipma-reference-time` resolves to a non-null `reference_time` within a second or two.
2. Open layers panel → "Previsão IPMA" section visible with all five toggles (`Temperatura`, `Vento`, `Direção do vento`, `Vento animado` if implemented, `Precipitação`, `Humidade`).
3. Toggle **Temperatura** → tiles render across mainland + Madeira + Açores **without** 404 in the network log. Each request URL includes `&reference_time=…`.
4. Toggle **Direção do vento** → barbs visible, contrast applied.
5. (Option 2 only) Toggle **Vento animado** → particle streamlines appear; tapping a location shows current wind speed + direction.
6. Toggle **IPMA FRP** under "Hotspots satélite" → renders independently, no `reference_time` needed.
7. Force-quit and relaunch → previously selected layers still on (persistence).
8. Airplane mode → toggles still respond, the layer fails silently (no crash); FRP and AROME hidden because tiles don't load. Re-enable network → tiles backfill.
9. Pull the device clock forward by 24 h → on next cold start, `/v1/ipma-reference-time` should return a different `reference_time` (because the backend cache expires); the new value flows into all AROME URLs.
10. Switch locale → labels (including `Vento animado`) translate.

---

# Addendum (2026-05-14, second wave): per-fire forecast charts

We've also shipped, on the fogos.pt web app, **eight Chart.js panels on every fire detail page** that mirror the click-point sidebar from `mf2.ipma.pt/continent`. They show 48 h hourly AROME forecast and 7-day LSA-SAF/RCM fire-index daily forecast for the exact (lat, lng) of the incident. This addendum is the brief to bring the same feature to the Flutter app on each incident detail screen.

## E. Backend already in place

A new Laravel endpoint does the heavy lifting on our side:

```
GET https://fogos.pt/v1/ipma-point/{lat}/{lng}
```

What it does:
1. Detects the IPMA region (`continent` / `madeira` / `azores`) from the lat/lng.
2. Resolves the latest available AROME `reference_time` (shared with `/v1/ipma-reference-time`).
3. Makes two **WMS `GetFeatureInfo`** calls — the trick MF2 uses — passing a comma-separated time list in the `time=` parameter. One call for AROME (hourly, 48 h), one for LSA-SAF + RCM (daily, 7 days).
4. Normalises the response, **injects `windU`/`windV` for direction arrows** by parsing the `arome.10m.windbarbs.{region}` value (which IPMA returns as a `[u, v]` array in m/s).
5. Caches in Redis under `ipma:point:{lat:.3f}:{lng:.3f}` for 1 hour and serves with `Cache-Control: public, max-age=1800`.

Error responses you may encounter:
- `422` → point is outside the IPMA regions (probably not in PT). Hide the section.
- `503` → IPMA unreachable / no current model run published yet. Show a discreet error message and keep the rest of the screen functional.

### E.1 Response shape

```json
{
  "lat": 40.123,
  "lng": -8.456,
  "region": "continent",
  "reference_time": "2026-05-13T12:00",
  "hourly": [
    {
      "datetime": "2026-05-13T19:00",
      "temperature": 18.7,
      "humidity": 58.5,
      "wind": 9.5,           // mean wind speed (km/h)
      "gust": 24.5,          // gust (km/h)
      "pressure": 1018.1,
      "precipitation": 0.0,
      "windU": 2.09,         // east component, m/s (for direction arrows)
      "windV": -1.63         // north component, m/s
    },
    /* …48 hourly entries, already sorted by datetime ascending… */
  ],
  "daily": {
    "fwi":    [ { "datetime": "2026-05-13T00:00", "value": 5.4 }, … ],
    "isi":    [ … ],
    "bui":    [ … ],
    "dc":     [ … ],
    "dmc":    [ … ],
    "ffmc":   [ … ],
    "p2000":  [ … ],
    "p2000a": [ … ],
    "rcm":    [ … ]
  }
}
```

Notes:
- Arrays may contain `null` values for individual days when IPMA hasn't published that index yet. Skip those points; do not let `null` reach the chart library.
- All arrays are pre-sorted ascending by datetime by the backend, so you can plot in order without re-sorting.
- The two arrays are time-disjoint: `hourly` covers `+0…+47 h`, `daily` covers `+0…+6 days` (one value per day, usually at 00:00 UTC). Don't try to merge them onto one axis.

## F. UX target on Flutter

Eight charts, in this order, each captioned with the title shown in §F.2. Mirrors the web app exactly so users get the same experience across platforms:

1. **Temperatura e humidade** — dual-axis line: temperature (left, °C) + humidity (right, %).
2. **Vento e rajada** — single line for `wind` + `gust`, **with arrows overlaid above the lines pointing where the wind is going** (one arrow every 2-3 hours so 48 timestamps stay readable).
3. **Pressão atmosférica** — single line, hPa.
4. **Precipitação acumulada** — bar chart, mm.
5. **FWI / ISI / BUI** — three daily lines (fire weather + initial spread + buildup indices).
6. **DC / DMC / FFMC** — three daily lines (drought + duff moisture + fine fuel moisture codes).
7. **FRM — probabilidade e anomalia** — two daily lines (`p2000` extremes probability + `p2000a` anomaly).
8. **RCM (estação)** — single daily line (station-based rural fire risk index).

Section title: **"Previsão IPMA neste ponto"** (PT) / **"IPMA forecast at this point"** (EN) / **"Previsión IPMA en este punto"** (ES). Source attribution underneath linking to https://www.ipma.pt.

## G. Flutter implementation

### G.1 Library choice — `fl_chart`

Use **`fl_chart`** (MIT, mature, ~17k stars). It's the de facto Flutter chart package, ships native Flutter widgets (no platform channels), supports `LineChart` and `BarChart`, and exposes raw `CustomPainter`-style hooks via `extraLinesData` and `customRenderers` — exactly what we need for the wind direction arrows overlay.

Avoid `charts_flutter` (Google's package, abandoned). Avoid `syncfusion_flutter_charts` (proprietary, free only under certain conditions).

Add to `pubspec.yaml`:

```yaml
dependencies:
  fl_chart: ^0.69.0
```

### G.2 Skeleton — a single `IpmaChartsCard` widget

Put this on the existing incident detail screen (likely `lib/screens/fire_details_screen.dart` or wherever the existing detail content lives — verify against the actual file). The widget owns its own loading/error state.

```dart
class IpmaChartsCard extends StatefulWidget {
  final double lat;
  final double lng;
  const IpmaChartsCard({super.key, required this.lat, required this.lng});

  @override
  State<IpmaChartsCard> createState() => _IpmaChartsCardState();
}

class _IpmaChartsCardState extends State<IpmaChartsCard> {
  late Future<IpmaPointData?> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchIpmaPoint(widget.lat, widget.lng);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<IpmaPointData?>(
      future: _future,
      builder: (ctx, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator()));
        }
        final data = snap.data;
        if (data == null) {
          // Either out-of-range or upstream failed — hide silently
          // unless we want a tiny inline message.
          return const SizedBox.shrink();
        }
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(L10n.of(context).ipmaChartsTitle, style: theme.titleMedium),
          _AttributionLine(),
          const SizedBox(height: 12),
          TempHumidityChart(hourly: data.hourly),
          WindChart(hourly: data.hourly),       // includes arrows overlay
          PressureChart(hourly: data.hourly),
          PrecipChart(hourly: data.hourly),
          FwiIsiBuiChart(daily: data.daily),
          DcDmcFfmcChart(daily: data.daily),
          FrmChart(daily: data.daily),
          RcmChart(daily: data.daily),
        ]);
      },
    );
  }
}
```

A simple model and fetcher:

```dart
class IpmaPointData {
  final String region;
  final String referenceTime;
  final List<IpmaHourly> hourly;
  final Map<String, List<IpmaDailyValue>> daily;
  IpmaPointData(this.region, this.referenceTime, this.hourly, this.daily);
}

class IpmaHourly {
  final DateTime t;
  final double? temperature, humidity, wind, gust, pressure, precipitation;
  final double? windU, windV;
  IpmaHourly(this.t, this.temperature, this.humidity, this.wind, this.gust,
             this.pressure, this.precipitation, this.windU, this.windV);
}

class IpmaDailyValue {
  final DateTime t;
  final double? value;
  IpmaDailyValue(this.t, this.value);
}

Future<IpmaPointData?> _fetchIpmaPoint(double lat, double lng) async {
  try {
    final r = await http.get(Uri.parse(
        'https://fogos.pt/v1/ipma-point/$lat/$lng'));
    if (r.statusCode != 200) return null;
    final j = jsonDecode(r.body) as Map<String, dynamic>;
    final hourly = (j['hourly'] as List).map((row) {
      final m = row as Map<String, dynamic>;
      double? d(String k) => m[k] is num ? (m[k] as num).toDouble() : null;
      return IpmaHourly(
        DateTime.parse(m['datetime'] as String),
        d('temperature'), d('humidity'), d('wind'), d('gust'),
        d('pressure'), d('precipitation'), d('windU'), d('windV'),
      );
    }).toList();
    final daily = <String, List<IpmaDailyValue>>{};
    (j['daily'] as Map<String, dynamic>).forEach((k, v) {
      daily[k] = (v as List).map((row) {
        final m = row as Map<String, dynamic>;
        final val = m['value'];
        return IpmaDailyValue(
          DateTime.parse(m['datetime'] as String),
          val is num ? val.toDouble() : null,
        );
      }).toList();
    });
    return IpmaPointData(
      j['region'] as String, j['reference_time'] as String, hourly, daily);
  } catch (_) {
    return null;
  }
}
```

### G.3 Wind direction arrows overlay

`fl_chart`'s `LineChart` accepts a `painter` style override through `extraLinesData` *and* you can stack a `CustomPaint` widget directly above the chart in a `Stack`. The latter is simpler.

```dart
class WindChart extends StatelessWidget {
  final List<IpmaHourly> hourly;
  const WindChart({super.key, required this.hourly});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.8,
      child: Stack(children: [
        LineChart(/* wind + gust series */),
        Positioned.fill(child: IgnorePointer(
          child: CustomPaint(painter: _WindArrowsPainter(hourly)),
        )),
      ]),
    );
  }
}
```

The painter projects each hourly point's index → x using the same horizontal extent as the chart (left padding = chart left axis label width, right padding ≈ 0), then draws a small arrow rotated by `atan2(-v, u)` (negate v because canvas Y is flipped). One arrow every 2 or 3 hours.

```dart
class _WindArrowsPainter extends CustomPainter {
  final List<IpmaHourly> hourly;
  _WindArrowsPainter(this.hourly);

  @override
  void paint(Canvas canvas, Size size) {
    final leftPad = 36.0, rightPad = 8.0, topPad = 18.0;
    final plotW = size.width - leftPad - rightPad;
    final step = hourly.length > 24 ? 3 : 2;
    final stroke = Paint()..color = Colors.black87..strokeWidth = 1.2;
    final fill = Paint()..color = Colors.black87..style = PaintingStyle.fill;
    for (var i = 0; i < hourly.length; i++) {
      if (i % step != 0) continue;
      final h = hourly[i];
      if (h.windU == null || h.windV == null) continue;
      final mag = sqrt(h.windU! * h.windU! + h.windV! * h.windV!);
      if (mag < 0.1) continue;
      final x = leftPad + plotW * (i / (hourly.length - 1));
      final y = topPad;
      final angle = atan2(-h.windV!, h.windU!);
      _drawArrow(canvas, Offset(x, y), angle, 11, stroke, fill);
    }
  }

  void _drawArrow(Canvas c, Offset center, double angle, double length,
                  Paint stroke, Paint fill) {
    final dx = cos(angle) * length / 2;
    final dy = sin(angle) * length / 2;
    final tail = center.translate(-dx, -dy);
    final head = center.translate(dx, dy);
    c.drawLine(tail, head, stroke);
    final left  = head.translate(cos(angle + pi - 0.5) * 4, sin(angle + pi - 0.5) * 4);
    final right = head.translate(cos(angle + pi + 0.5) * 4, sin(angle + pi + 0.5) * 4);
    final path = Path()..moveTo(head.dx, head.dy)
                       ..lineTo(left.dx, left.dy)
                       ..lineTo(right.dx, right.dy)..close();
    c.drawPath(path, fill);
  }

  @override
  bool shouldRepaint(_) => false;
}
```

The exact `leftPad` / `rightPad` need to match whatever `fl_chart` uses for its title/axes — measure once with the first run and tweak. Alternatively, listen to `LineChartData.lineTouchData.touchTooltipData` callbacks to extract the exact data-area rect — but the static padding approach is good enough.

### G.4 Charts that take two y-axes

Only the temperature+humidity chart needs dual axis. In `fl_chart`, this is done by giving each `LineChartBarData` its own normalised data and showing two separate `LeftTitles` widgets — or, simpler, scale the humidity values to share the temperature axis range. For parity with the web, use proper dual axis via `LineChartData.lineBarsData[N].belowBarData` ranges: configure `extraLinesData` for the second axis labels manually.

Pragmatic alternative: render two separate stacked charts in one card — "Temperatura (°C)" on top, "Humidade (%)" below, sharing the x axis labels. Less elegant but bullet-proof in `fl_chart`.

## H. i18n strings to add

Mobile app probably uses `intl` / .arb files. Add the same key set we have in PHP:

| Key | PT | EN | ES |
|---|---|---|---|
| `ipmaChartsTitle` | Previsão IPMA neste ponto | IPMA forecast at this point | Previsión IPMA en este punto |
| `ipmaChartsSource` | Dados: | Data: | Datos: |
| `ipmaChartsError` | Não foi possível obter dados da IPMA para esta localização. | Could not load IPMA data for this location. | No se pudieron obtener datos de IPMA para esta ubicación. |
| `chartTemperature` | Temperatura (°C) | Temperature (°C) | Temperatura (°C) |
| `chartHumidity` | Humidade (%) | Humidity (%) | Humedad (%) |
| `chartWind` | Vento médio (km/h) | Mean wind (km/h) | Viento medio (km/h) |
| `chartGust` | Rajada (km/h) | Gust (km/h) | Ráfaga (km/h) |
| `chartPressure` | Pressão (hPa) | Pressure (hPa) | Presión (hPa) |
| `chartPrecipitation` | Precipitação (mm) | Precipitation (mm) | Precipitación (mm) |
| `chartFwi/Isi/Bui/Dc/Dmc/Ffmc` | (same in all locales) | | |
| `chartP2000` | Probabilidade de extremos | Extremes probability | Probabilidad de extremos |
| `chartP2000a` | Anomalia | Anomaly | Anomalía |
| `chartRcm` | RCM (estação) | RCM (station) | RCM (estación) |
| `titleTempHum` | Temperatura e humidade | Temperature and humidity | Temperatura y humedad |
| `titleWind` | Vento e rajada | Wind and gust | Viento y ráfaga |
| `titlePressure` | Pressão atmosférica | Atmospheric pressure | Presión atmosférica |
| `titlePrecip` | Precipitação acumulada | Accumulated precipitation | Precipitación acumulada |
| `titleFwi` | FWI / ISI / BUI | (same) | (same) |
| `titleDc` | DC / DMC / FFMC | (same) | (same) |
| `titleFrm` | FRM — probabilidade e anomalia | FRM — probability and anomaly | FRM — probabilidad y anomalía |
| `titleRcm` | RCM (estação) | RCM (station) | RCM (estación) |

## I. Performance and offline notes

- The endpoint response is ~20 KB; cheap to fetch over mobile.
- Our backend already caches 1 hour per (lat, lng) and the response carries `Cache-Control: public, max-age=1800`, so Dio/Flutter `http` will reuse it within that window across re-opens of the same incident. No need for a custom cache layer.
- When the user opens a detail page offline, the future fails → `data == null` → section is hidden. The rest of the screen renders fine.
- Don't aggressively re-fetch when the user pulls-to-refresh on the detail screen — once per incident open is plenty (the data updates twice a day at most).

## J. Verification checklist

1. Open the detail screen for an incident in mainland Portugal → after a 1-2 s shimmer, eight charts render. The header reads "Previsão IPMA neste ponto" plus the IPMA link.
2. Wind chart: arrows visible above the line, pointing in physically plausible directions (verify against MF2 if unsure: open `https://mf2.ipma.pt/continent?query={lat},{lng}` and compare).
3. Incident in Madeira or Açores → still works, region in response payload is `madeira` / `azores`.
4. Incident outside PT regions (e.g. test with synthetic lat/lng in Spain) → backend returns 422 → section hidden, no error toast.
5. Airplane mode → section hidden, no crash.
6. Switch device locale → all labels and titles translate.
7. Pull-to-refresh on the detail screen → IPMA section refetches; if backend cache still warm, response is instant (it's coming from our Redis).
8. Profile mode → no jank when scrolling past the eight charts. If observed, lower `aspectRatio` or render off-screen charts lazily.

## K. Updated quick reference

```dart
// New endpoint added on the backend:
//   GET https://fogos.pt/v1/ipma-point/{lat}/{lng}
//   → 200 { region, reference_time, hourly[], daily{} }
//   → 422 if point outside the IPMA regions
//   → 503 if IPMA unreachable

Future<IpmaPointData?> fetchIpmaPoint(double lat, double lng) async {
  final r = await http.get(Uri.parse('https://fogos.pt/v1/ipma-point/$lat/$lng'));
  return r.statusCode == 200 ? IpmaPointData.fromJson(jsonDecode(r.body)) : null;
}
```

The integration points in the existing Flutter code: wherever the fire detail screen is rendered, add `IpmaChartsCard(lat: fire.lat, lng: fire.lng)` near the bottom of the existing content (after status / meteo, before any "shares" widget). State management — if the project uses Redux/BLoC — should keep the future inside the widget rather than putting it in the store, because the data is single-screen and cached at network layer.
