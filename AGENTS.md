# Project Guidelines for AI Collaborators

## 1. Feature-Oriented Development

* **Context Awareness:** Work is scoped to specific features. Be mindful of surrounding code. Do not introduce broad changes unless necessary.
* **Consistency:** Maintain existing naming conventions and logic flow.

## 2. Platform & Compatibility Rules

* **Platform Agnostic by Default:** The code is cross-platform. Do not assume the app only runs on Linux.
* **Development Convenience:** Desktop-specific window configurations (e.g., `window_manager`) are for **development convenience only**.
  * Wrap in `if (Platform.isLinux || Platform.isWindows || Platform.isMacOS)` checks.
  * The application must remain responsive on mobile devices without these configurations.

## 3. Import Standards

* **Default to Full Imports:** Use full imports (e.g., `import 'package:flutter/material.dart';`).
* **Exceptions:** Only use `show` or `hide` for direct naming collisions or to filter significant namespace pollution from specific third-party libraries.

## 4. Testability & Development Workflow

* **Test-First Mindset:** Logic must be testable. Prioritize modularity and Dependency Injection.
* **Mandatory Testing:** When generating code, provide unit/widget tests using `flutter_test`.
* **Mocking:** Include necessary mocks for external APIs or platform services.

## 5. Reporting & Documentation

* **Changelog Maintenance:** Update `CHANGELOG.md` (Keep a Changelog format) when merging features into the main branch.
* **Interaction:** If a request is ambiguous, ask for clarification before generating large amounts of code.
