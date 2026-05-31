# Computology Modules

Authentication, Home, and Profile modules built with Flutter Material 3.

## Features

- Authentication: Login, Register, Forgot Password (form validation + routing)
- Home: Banner carousel, category chips, featured products grid, bottom nav
- Profile: View profile, edit profile, settings shortcuts, logout
- Bonus: Dark mode toggle and local storage via SharedPreferences

## Project Structure

```sh
lib/
├── main.dart
├── models/
├── providers/
├── screens/
│   ├── auth/
│   ├── home/
│   └── profile/
├── services/
├── utils/
└── widgets/
```

## Run

```sh
flutter pub get
flutter run
```

## Notes

- Mock data lives in `lib/services/mock_data.dart`.
- Local storage is handled in `lib/services/local_storage_service.dart`.
- The Search and Cart tabs are placeholders for future module integration.
