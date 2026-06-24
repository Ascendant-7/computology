# 🚀 Project Setup & Developer Onboarding

Welcome to the **Computology** repository! Follow this guide to get your local environment configured for development, testing, and Firebase synchronization.

---

## 💻 Prerequisites

Ensure you have the following installed on your machine:

* **Flutter SDK:** Stable channel.
* **Google Chrome:** Required for local web-based execution and E2E automation.
* **pnpm:** For managing localized development tooling.

---

## 🔐 Step 1: Clone & Generate Firebase Configuration (Mandatory)

Because our project security standards keep `lib/firebase_options.dart` git-ignored, **every developer must generate this configuration file locally before the application can compile.**

1. Clone the repository and navigate to the project root:

```bash
git clone <repository-url>
cd computology

```

1. Fetch all required Flutter dependencies:

```bash
flutter pub get

```

1. Install the official **Firebase CLI** using the standalone installation script:

```bash
curl -sL https://firebase.tools | bash

```

1. Authenticate your terminal session with the shared Firebase workspace credentials:

```bash
firebase login

```

1. Activate the **FlutterFire CLI** engine globally through Dart:

```bash
dart pub global activate flutterfire_cli

```

1. Run the configuration tool to pull down the required API keys and generate your missing `lib/firebase_options.dart` file automatically:

```bash
flutterfire configure --platforms=web

```

1. Launch the application inside a local Chrome window to verify the setup:

```bash
flutter run -d chrome

```

---

## 🧪 Step 2: Automated E2E Testing Environment

We utilize standard automated drivers to handle End-to-End (E2E) usability verification testing straight from your web browser.

### Local ChromeDriver Setup

To run integration tests locally, your system needs a lightweight native driver to control Chromium.

1. Download the stable platform-specific driver executable via `pnpm`:

```bash
pnpm dlx @puppeteer/browsers install chromedriver@stable

```

1. Move **only** the raw `chromedriver` binary into your system's user-level binary path to keep your home directory clean:

```bash
mkdir -p ~/.local/bin
cp chromedriver/linux64-*/chromedriver ~/.local/bin/
rm -rf ~/chromedriver

```

### Executing the E2E Test Suite

1. In a separate background terminal window, spin up the automation bridge server:

```bash
chromedriver --port=4444 &

```

1. Execute the test driver sequence:

```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart \
  -d chrome

```

---

## 📁 Repository Best Practices

* **Keep Configs Local:** Never force-commit `lib/firebase_options.dart` to a pull request. If backend changes or new features are introduced, run `flutterfire configure --platforms=web` again to update your local copy.
* **UI Sizing Adjustments:** Do not import custom desktop layout or window-resizing packages. Use Chrome DevTools Device Mode (`F12 -> Toggle Device Toolbar`) to mirror phone or tablet scaling directly in-browser.
