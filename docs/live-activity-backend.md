# "Seguir incêndio" backend — spec

Real-time updates for the "seguir incêndio" feature on iOS (Live Activity)
and Android (ongoing notification). Two independent delivery paths so each
platform uses the mechanism it does best.

- **iOS**: per-activity APNs push tokens, registered via HTTP endpoints, and
  the backend sends `apns-push-type: liveactivity` payloads directly to APNs.
- **Android**: FCM topic subscription `follow-fire-<fireId>`, and the
  backend sends FCM data messages to that topic.

**Privacy:** the app never sends the user's location. Backend only receives
`fireId + pushToken + env` (iOS) or subscribes an anonymous FCM instance to
a topic (Android). Distance calculations, if ever surfaced, happen on-device.

---

## iOS — HTTP endpoints (implemented on backend)

Base: `https://api.fogos.pt/v2/incidents/{id}/live-activity`

Nested under `/v2/incidents/{id}/...` for consistency with the existing
photos and posit endpoints. `fireId` travels in the URL path, never in the
body. Public auth + `liveactivity.ratelimit` middleware
(per-IP-per-minute + per-incident-global-per-hour, same pattern as
`photo.ratelimit`).

### `POST /v2/incidents/{id}/live-activity/register`

Called when the app captures a fresh push token (initial start, or when
Apple rotates the token mid-activity).

Body:
```json
{
  "pushToken": "a1b2c3...",     // hex-encoded, ≥ 64 chars
  "env": "sandbox"              // or "production"
}
```

Backend flow:
1. `Incident::whereFireId($id)->firstOrFail()`.
2. Validate `pushToken` (hex, ≥ 64 chars) and `env ∈ {sandbox, production}`.
3. `LiveActivityToken::updateOrCreate(['fire_id' => $id, 'push_token' => $t], ['env' => $env])->touch()`
   — idempotent upsert on `(fire_id, push_token)`, refresh `updated_at`.
4. Response: `200 { "success": true }`.

### `POST /v2/incidents/{id}/live-activity/unregister`

Called when the user stops following, or when a token becomes invalid.

Body:
```json
{
  "pushToken": "a1b2c3..."
}
```

Deletes the row if it exists. Always returns `200 { "success": true }`,
even if the row was missing (idempotent). Also fine to prune automatically
when APNs replies 410 Gone — the app-side unregister may not always run
(e.g. iOS killed the app).

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

## Android — FCM data messages

The Android app subscribes to FCM topic `follow-fire-<fireId>` when the
user taps "Seguir este incêndio", and unsubscribes on "Deixar de seguir".
**No new backend endpoint or database is needed** — the FCM registry
transparently tracks subscribers.

When a fire changes, send a **data-only** FCM message to that topic:

```json
{
  "message": {
    "topic": "follow-fire-abc123",
    "data": {
      "type": "follow-fire-update",
      "fireId": "abc123",
      "title": "🔥 Sintra",
      "location": "Sintra · Colares · Ao Alto",
      "statusText": "Em Curso",
      "statusColor": "#FF512F",
      "human": "42",
      "terrain": "12",
      "aerial": "2",
      "isFire": "true",
      "event": "update"
    },
    "android": {
      "priority": "high"
    }
  }
}
```

- All `data` values must be **strings** — that's an FCM constraint. The
  client parses `human`/`terrain`/`aerial` as ints and `isFire` as bool.
- Do **not** include a top-level `notification` field. A pure data message
  lets the Dart background handler process it silently and update the
  existing ongoing notification, instead of Firebase auto-posting a new
  system notification alongside.
- `android.priority: "high"` is required to wake the app in Doze mode.
- `apns` block can be omitted — this message is Android-only. iOS
  subscribers of the FCM topic (if any) would receive it too but the client
  ignores it on iOS (LA updates go via APNs directly).

For **end** events (fire resolved):
```json
{
  "message": {
    "topic": "follow-fire-abc123",
    "data": { "type": "follow-fire-update", "fireId": "abc123", "event": "end" },
    "android": { "priority": "high" }
  }
}
```

The client dismisses the notification when `event=end`. FCM's own topic
subscribers list can be pruned by simply skipping further sends for that
`fireId` — no cleanup call is needed.

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
