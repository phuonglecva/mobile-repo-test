# Getting started

## Requirements

- Flutter SDK on the stable channel
- Dart SDK included with Flutter
- Android Studio (Android SDK + platform tools) or another Android SDK installation
- A physical Android device with USB debugging or an Android emulator

Recommended baseline: Flutter 3.24+ and Dart 3.5+. Newer stable Flutter versions are preferred.

## 1. Clone

~~~bash
git clone https://github.com/phuonglecva/mobile-repo-test.git
cd mobile-repo-test
~~~

## 2. Check Flutter

~~~bash
flutter --version
flutter doctor -v
~~~

Resolve Android toolchain warnings in flutter doctor before building.

## 3. Generate Android platform files (first clone only)

This repository keeps the app source and build configuration in version control. Generate the standard Android runner with Flutter:

Ubuntu:
~~~bash
bash scripts/bootstrap_android.sh
~~~

Windows PowerShell:
~~~powershell
.\scripts\bootstrap_android.ps1
~~~

The scripts are safe to re-run if the Android folder is already present.

## 4. Install packages

~~~bash
flutter pub get
~~~

## 5. Run the app

List available devices:
~~~bash
flutter devices
~~~

Run on an Android emulator or connected phone:
~~~bash
flutter run
~~~

Hot reload is available by pressing r in the terminal.

## Run on Ubuntu desktop (optional)

Install the Linux desktop build dependencies:
~~~bash
sudo apt-get update
sudo apt-get install -y clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev
~~~

Enable Linux desktop once:
~~~bash
flutter config --enable-linux-desktop
flutter create --platforms=linux .
flutter run -d linux
~~~

## Run on Windows desktop (optional)

Install Visual Studio 2022 with the Desktop development with C++ workload. Then run:
~~~powershell
flutter config --enable-windows-desktop
flutter create --platforms=windows .
flutter run -d windows
~~~

Android remains the primary target; desktop support is intended for development and UI review.
