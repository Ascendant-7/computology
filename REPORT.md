# Computology Modules Report

Date: May 31, 2026

## Objective
<<<<<<< HEAD
Build Authentication, Home, and Profile modules using Flutter Material 3 with clean structure, state management, mock data, and navigation that can integrate with Search/Cart later.

## Scope Delivered
=======

Build Authentication, Home, and Profile modules using Flutter Material 3 with clean structure, state management, mock data, and navigation that can integrate with Search/Cart later.

## Scope Delivered

>>>>>>> dev
- Authentication module: Login, Register, Forgot Password screens with validation and navigation.
- Home module: Banner carousel, categories, featured products grid, and bottom navigation.
- Profile module: Profile view, edit profile, menu actions, logout, and theme toggle.
- App architecture: Provider state management, local storage, reusable widgets, and Material 3 theme.

## Architecture Overview
<<<<<<< HEAD
=======

>>>>>>> dev
- State management: Provider for auth, profile, and theme.
- Storage: SharedPreferences to persist theme and profile data.
- Mock data: Centralized product, banner, and profile data.
- Navigation: Named routes and auth-aware app entry.

## Technologies Used
<<<<<<< HEAD
=======

>>>>>>> dev
- Flutter (Material 3) and Dart SDK 3.12
- Provider for state management
- SharedPreferences for local persistence
- Carousel Slider for banner carousel UI
- Google Fonts for typography
- Flutter Lints for code quality

## Project Structure
<<<<<<< HEAD
```
=======

```sh
>>>>>>> dev
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

## Key Modules and Responsibilities

### Authentication
<<<<<<< HEAD
=======

>>>>>>> dev
- Login screen with email/password, show/hide password, and login button.
- Register screen with full name, email, password, confirm password and validation.
- Forgot password screen with reset workflow and success feedback.
- Navigation to Home on success.

### Home
<<<<<<< HEAD
=======

>>>>>>> dev
- App bar with logo, search, notifications.
- Banner section using Carousel Slider.
- Categories chips with icons.
- Featured products grid with card UI, image, price, rating, and details button.
- Bottom navigation for Home, Search, Cart, and Profile.

### Profile
<<<<<<< HEAD
=======

>>>>>>> dev
- Profile header with image, name, email.
- Menu actions: Edit Profile, Order History, Settings, Logout.
- Edit Profile screen for name, email, and avatar URL updates.
- Theme toggle (Light/Dark) stored locally.

## Functionality Summary
<<<<<<< HEAD
=======

>>>>>>> dev
- Authentication flow: login, register, forgot password, and auth-aware entry routing.
- Home browsing: banner carousel, category filters, and featured products grid.
- Profile management: view and edit profile, persist profile data locally.
- Preferences: dark/light theme toggle with saved settings.
- Navigation: bottom navigation for Home, Search, Cart, Profile.

## Key Code Functions and Classes
<<<<<<< HEAD
=======

>>>>>>> dev
- App entry and routing: main.dart, app_routes.dart.
- State management: AuthProvider, ProfileProvider, ThemeProvider.
- Local persistence: LocalStorageService using SharedPreferences.
- Data layer: MockDataService for banners, categories, products, and profile.
- Reusable UI: AppTextField, PrimaryButton, ProductCard, BannerCarousel.

## Technical Requirements Mapping
<<<<<<< HEAD
=======

>>>>>>> dev
- Material 3 design: Applied in app theme.
- Responsive layout: Grid adapts by width breakpoints.
- Reusable widgets: Text fields, buttons, cards, chips, section headers.
- Null safety: Enabled by default in Flutter 3+ project.
- Mock data: Centralized in mock data service.
- Navigation: Named routes and auth-aware landing.

## Important Files
<<<<<<< HEAD
=======

>>>>>>> dev
- App entry and routing: lib/main.dart
- Theme: lib/utils/app_theme.dart
- Routes: lib/utils/app_routes.dart
- Mock data: lib/services/mock_data.dart
- Providers: lib/providers/*
- Screens: lib/screens/*
- Widgets: lib/widgets/*

## Current Mock Data Notes
<<<<<<< HEAD
=======

>>>>>>> dev
- Featured products set to Lenovo, Mac, MSI, and ASUS laptops.
- Profile avatar updated to the provided GitHub avatar URL.

## How To Run
<<<<<<< HEAD
```
=======

```sh
>>>>>>> dev
flutter pub get
flutter run
```

## Bonus Status
<<<<<<< HEAD
=======

>>>>>>> dev
- Dark mode: Implemented with toggle and persisted setting.
- Local storage: Implemented with SharedPreferences.
- Firebase Authentication: Not implemented; ready to integrate.

## Future Enhancements
<<<<<<< HEAD
=======

>>>>>>> dev
- Hook auth actions into Firebase Auth.
- Replace placeholder Search/Cart screens with real modules.
- Add product details screen and cart integration.
- Add image caching and offline-friendly data layer.
