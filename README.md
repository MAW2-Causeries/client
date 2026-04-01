# Causeries Client (Flutter)

Flutter client for Causeries.

This app is built with a feature-first structure. It talks to the backend via HTTP (REST) and receives realtime events via WebSocket.

## Requirements

- Flutter SDK (Dart 3.x)
- A running Causeries API server

## Setup

1) Install dependencies

```bash
flutter pub get
```

2) Configure environment

Create a `.env` file at the repo root:

```env
API_BASE_URL=http://127.0.0.1:3000/api/v1
```

Notes:
- `API_BASE_URL` must include `/api/v1`.
- `.env` is git-ignored.

3) Run the app

```bash
flutter run
```

## Tests

Run the full test suite:

```bash
flutter test
```

This repo uses Mockito. If you add new `@GenerateNiceMocks(...)` annotations, regenerate mocks with:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Architecture (Feature-first)

High-level layout:

```text
lib/
  app/                # routes, DI, theme
  core/               # shared infrastructure (network, storage)
  features/
    authentication/
    guilds/
    users/
```

Within a feature, code is organized by responsibility:

- `data/`: DTOs, API services, repository implementations
- `domain/`: entities + repository interfaces
- `presentation/`: screens/widgets + view models/controllers

## Networking

HTTP calls go through `lib/core/network/api_client.dart`.

- Auth uses a Bearer token stored in secure storage (`lib/core/storage/token_storage.dart`).
- List responses may be JSON arrays; the client normalizes non-map responses into `{ "data": ... }`.

## Realtime (WebSocket)

Realtime is handled by `lib/core/network/realtime_client.dart`.

- WebSocket endpoint: `GET /api/v1/ws` (upgrades to WS)
- Auth: `Authorization: Bearer <token>` during the upgrade
- Server pushes newly created messages for channels the authenticated user belongs to.

Message payload example:

```json
{
  "author_id": "...",
  "channel_id": "...",
  "content": "...",
  "created_at": "2026-04-01T19:53:28Z",
  "deleted_at": null,
  "id": "...",
  "updated_at": "2026-04-01T19:53:28Z"
}
```

## Messaging

Sending a message (HTTP):

- `POST /api/v1/channels/{channelId}/messages`
- body: `{ "content": "string" }`

Loading channel history (HTTP):

- `GET /api/v1/channels/{channelId}/messages`

Author display names are resolved via:

- `GET /api/v1/users/{id}` -> `{ id, email, username }`

## Common issues

- If the API base URL is wrong, you will see connection errors immediately. Verify `API_BASE_URL` includes `/api/v1`.
- After changing networking code, do a full restart (stop `flutter run` and run again) to avoid hot-reload state masking issues.
