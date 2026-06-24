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

## 6. Firebase Integration

* **No-Ownership**: If Firebase is integrated, you are allowed to generate code relating to Firebase query, but NEVER about Firebase configuration. If a configuration is required, there is a file called `FIREBASE_CONSUMER.md` that you add ask an issue for Ang Panha, the team lead, to deal with.

* **No-Development**: Firebase will be integrated by Ang Panha, the team lead. He doesn't use any agent because he's tuff. Therefore, any generated code has to NEVER include Firebase integration, even if required. If the generated code requires firebase integration, you must do the following:

  1. Place placeholder code or comment with **TODO**.
  2. Add the filename and line number in the file `FIREBASE_CONSUMER.md` under **File Requiring Firebase Integration**, at the root of this project. Also, specify what data it wants to query with Firebase.
