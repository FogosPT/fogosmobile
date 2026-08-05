# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Fogos.pt mobile app — a Flutter app for tracking wildfires in Portugal in real-time, using Mapbox for visualization and Firebase for notifications.

## Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Lint / static analysis
flutter analyze

# Run tests
flutter test

# Clean build artifacts
flutter clean

# Build release
flutter build apk       # Android APK
flutter build aab       # Android App Bundle
flutter build ios       # iOS
```

The project uses [FVM](https://fvm.app/) (Flutter Version Manager). Check `.fvmrc` for the pinned Flutter version. Use `fvm flutter` instead of `flutter` if using FVM.

## Architecture

### State Management: Redux

The app uses a strict Redux pattern:

- **Store** (`lib/store/app_store.dart`): Single global `store` singleton
- **State** (`lib/models/app_state.dart`): Root immutable state tree
- **Actions** (`lib/actions/`): Plain objects dispatched to trigger changes
- **Reducers** (`lib/reducers/`): Pure functions — `app_reducer.dart` orchestrates all domain reducers
- **Middleware** (`lib/middleware/`): Handles async API calls and side effects (HTTP requests, SharedPreferences persistence)

When adding a new feature, you typically need to create/update all five layers.

### Navigation

Named routes defined in `lib/constants/routes.dart`. Navigation is done via `Navigator.pushNamed()`. The main navigation entry point is `FirstPage` (in `main.dart`) which renders a drawer.

### Key UI Structure

- `lib/screens/home_page.dart` — Main map view (Mapbox)
- `lib/screens/widgets/fogos_map.dart` — Mapbox map widget with fire markers, MODIS/VIIRS overlays
- `lib/screens/fire_details.dart` — Fire detail screen
- `lib/screens/components/fire_details.dart` — Fire detail bottom sheet modal
- `lib/screens/settings/` — Notification and preference settings

### Data Layer

- All API endpoints are in `lib/constants/endpoints.dart`
- API base: `source.fogos.pt`
- HTTP via `http` and `dio` packages
- Persistent preferences via `SharedPreferences` (managed through `lib/middleware/shared_preferences_manager.dart`)

### Notifications

- Firebase Cloud Messaging (FCM) for push notifications — configured in `main.dart`
- `lib/services/nearby_notification_service.dart` — geolocation-based nearby fire alerts
- `lib/services/fcm_migration_service.dart` — handles FCM topic migration on app updates

### Localization

Supports Portuguese (PT) and English (US). Localization strings are in `lib/localization/`. Generated files live in `lib/localization/generated/`. Run `flutter gen-l10n` to regenerate after changing `.arb` files.

### Theme

Centralized in `lib/styles/theme.dart`. Primary color: `#ff512f` (red), accent: `#f09819` (orange).

### CI/CD

Builds are handled by Codemagic. Mapbox authentication for Codemagic is in `.codemagic/.netrc`.
