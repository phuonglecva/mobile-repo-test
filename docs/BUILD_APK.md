# Build Android APK

## Debug APK

Useful for quick local testing:
~~~bash
flutter pub get
flutter build apk --debug
~~~

## Release APK

~~~bash
flutter pub get
flutter build apk --release
~~~

The universal release APK is created at:

    build/app/outputs/flutter-apk/app-release.apk

Install on a connected device:
~~~bash
flutter install
~~~

Or copy the APK to an Android device and install it manually. For Play Store distribution, configure a private signing key and an Android App Bundle (flutter build appbundle --release); do not commit signing keys or passwords.

## Ubuntu build environment

~~~bash
sudo apt-get update
sudo apt-get install -y curl git unzip xz-utils zip libglu1-mesa
flutter doctor -v
bash scripts/bootstrap_android.sh
flutter pub get
flutter build apk --release
~~~

Install Android Studio / Android SDK and accept licenses:
~~~bash
flutter doctor --android-licenses
~~~

## Windows build environment

Use PowerShell:
~~~powershell
.\scripts\bootstrap_android.ps1
flutter pub get
flutter build apk --release
~~~

Install Android Studio and Android SDK, then accept licenses:
~~~powershell
flutter doctor --android-licenses
~~~

## CI artifact

The GitHub Actions workflow at .github/workflows/android-apk.yml builds a release APK on pushes to main and manual workflow dispatch. Download the milo-english-release-apk artifact from the completed GitHub Actions run.
