# Computology

A E-commerce mobile application for a computer shop built in Flutter. It features product catalog, cart management and order tracking.

## Members

| No | Name | ID | Role |
| -- | ---- | -- | ---- |
| 1 | Ang Panha | e20221707 | Team Lead |
| 2 | Et Anchhy | e20220608 | Member |
| 3 | Thou Laiheng | e20220843 | Member |

## Features

- Authentication: Login, Register, Forgot Password (form validation + routing)
- Home: Banner carousel, category chips, featured products grid, bottom nav
- Profile: View profile, edit profile, settings shortcuts, logout
- Bonus: Dark mode toggle and local storage via SharedPreferences

## Project Structure

```sh
lib
├── app.dart
├── core
│   ├── network
│   ├── theme
│   ├── utils
│   └── widgets
├── features
│   ├── auth
│   ├── cart
│   ├── catalog
│   └── profile
└── main.dart
```

## Run

```sh
flutter pub get
flutter run
```

## Notes

- Mock data lives in `lib/services/mock_data.dart`.
- Local storage is handled in `lib/services/local_storage_service.dart`.
- The Search tab is a placeholder for future module integration.
