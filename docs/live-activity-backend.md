# Live Activity backend — spec

The iOS app opens a Live Activity when the user taps "Seguir este incêndio",
asks Apple for a per-activity push token, and sends it to the backend so
APNs can deliver real-time updates while the app is closed.

**Privacy:** the app never sends the user's location. Backend only receives
`fireId + pushToken + env`. Distance calculations, if ever surfaced, happen
on-device.

---

## Endpoints (implemented on backend)

Base: `https://api.fogos.pt/v2/live-activity`

### `POST /register`

Called when the app captures a fresh push token (initial start, or when
Apple rotates the token mid-activity).

Request:
```json
{
  "fireId": "abc123",
  "pushToken": "a1b2c3...",     // hex-encoded, 64+ chars
  "env": "sandbox"              // or "production"
}
```

Behaviour: idempotent upsert on `(fireId, pushToken)`; refresh `updated_at`.

Response: `200 { "success": true }`

### `POST /unregister`

Called when the user stops following, or when a token becomes invalid.

Request:
```json
{
  "fireId": "abc123",
  "pushToken": "a1b2c3..."
}
```

Response: `200 { "success": true }`

Also fine to unregister automatically when APNs replies 410 Gone for a
token — the app-side unregister may not always run (e.g. iOS killed the app).

---

## Storage

Minimal table:

```sql
CREATE TABLE live_activity_tokens (
  id           BIGSERIAL PRIMARY KEY,
  fire_id      TEXT NOT NULL,
  push_token   TEXT NOT NULL,
  env          TEXT NOT NULL CHECK (env IN ('sandbox', 'production')),
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (fire_id, push_token)
);

CREATE INDEX ON live_activity_tokens (fire_id);
```

---

## Trigger: when a fire changes

Whenever a fire's meios or status changes, fetch subscribers and push:

```sql
SELECT push_token, env FROM live_activity_tokens WHERE fire_id = $1;
```

For each row, do an HTTP/2 POST to APNs.

**URL** (per row's `env`):
- production: `https://api.push.apple.com:443/3/device/<push_token>`
- sandbox:    `https://api.sandbox.push.apple.com:443/3/device/<push_token>`

**Headers**:
```
:method: POST
:path: /3/device/<push_token>
content-type: application/json
apns-topic: com.tomahock.fogos.push-type.liveactivity
apns-push-type: liveactivity
apns-priority: 10
apns-expiration: <unix seconds, e.g. now + 3600>
authorization: bearer <JWT>
```

**JWT** (ES256 signed with your `.p8` auth key):
- Header: `{ "alg": "ES256", "kid": "<KEY_ID>", "typ": "JWT" }`
- Claims: `{ "iss": "<TEAM_ID>", "iat": <unix seconds> }`
- Team ID for Fogos.pt: `RNKVG428JH`
- Cache the JWT for up to 55 min (Apple rejects tokens older than 60 min).

Get the `.p8` at Apple Developer → Certificates, Identifiers & Profiles →
**Keys** → **+** → check **Apple Push Notifications service (APNs)** → Continue → Register.
Download the `AuthKey_<KEY_ID>.p8` (only once — Apple doesn't let you re-download it).

**Body — update event** (regular meios/status change):
```json
{
  "aps": {
    "timestamp": 1751234567,
    "event": "update",
    "content-state": {
      "statusText": "Em Curso",
      "statusColorHex": "#FF512F",
      "human": 42,
      "terrain": 12,
      "aerial": 2,
      "distanceKm": null,
      "updatedAt": 1751234567
    },
    "stale-date": 1751238167
  }
}
```

- `timestamp`, `updatedAt`, `stale-date`: unix seconds (integer).
- `statusColorHex`: `#RRGGBB` string (same format the fires API already returns).
- `distanceKm`: **always `null`** — backend does not know user location.
- `stale-date`: when the LA should visually mark itself as stale if no
  further update arrives. Recommended: `now + 1h`.

**Body — end event** (fire status becomes Encerrada / Falso Alarme / Falso Alerta):
```json
{
  "aps": {
    "timestamp": 1751234567,
    "event": "end",
    "content-state": {
      "statusText": "Encerrada",
      "statusColorHex": "#00A000",
      "human": 0,
      "terrain": 0,
      "aerial": 0,
      "distanceKm": null,
      "updatedAt": 1751234567
    },
    "dismissal-date": 1751238167
  }
}
```

After the end event, the LA is dismissed by iOS after `dismissal-date`
(recommend `now + 1h` so the user sees the final state on the lock screen
briefly). The backend should also DELETE the row from
`live_activity_tokens` since no more pushes are needed.

---

## Response handling

Interpret APNs replies:

- `200`: delivered — nothing to do.
- `400`: bad payload — log and drop this push (bug on our side).
- `403`: bad `authorization` — regenerate JWT.
- `410 Gone`: this push token is no longer valid — `DELETE FROM
  live_activity_tokens WHERE push_token = $1` for both envs.
- `429`: rate limited — back off; safe to retry with jitter.
- `5xx`: retry with exponential backoff.

---

## Client-side flow (already implemented)

For reference — how the app interacts:

1. User taps "Seguir este incêndio" → `LiveActivityService.start(fire)` in Dart.
2. Swift bridge calls `Activity.request(pushType: .token)`.
3. Swift starts observing `activity.pushTokenUpdates` (an `AsyncSequence`).
4. When Apple delivers a token, Swift invokes the Flutter method channel
   with `pushTokenUpdate` (`fireId`, `pushToken`, `env`).
5. Dart calls `POST /register`.
6. When the user stops following, or the activity ends naturally, Dart
   calls `POST /unregister`.

Files involved:
- `ios/Runner/LiveActivityBridge.swift`
- `lib/services/live_activity_service.dart`
- `lib/services/live_activity_backend.dart`
