# OpenTube Flutter Development Instructions

OpenTube is a third-party YouTube client built with Flutter targeting OpenHarmony, Android, and iOS platforms. It includes a custom Innertube API implementation for YouTube data access.

**ALWAYS follow these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.**

## Working Effectively

### Prerequisites and Setup
Install Flutter SDK using ONE of these methods (try in order):
1. **Recommended**: `sudo snap install flutter --classic` (Linux)
2. **Git method**: `git clone --depth 1 --branch stable https://github.com/flutter/flutter.git` then add to PATH
3. **Download**: Download from https://flutter.dev/docs/get-started/install

**Environment Notes:**
- Some network environments may block Flutter SDK downloads - try different installation methods
- Corporate firewalls may prevent pub.dev package downloads
- If downloads fail, Flutter commands will show specific error messages

Ensure you have the following tools installed:
- Git
- Chrome/Chromium (for web development) 
- Android Studio (for Android development)
- Xcode (for iOS development, macOS only)

### Essential Commands - CRITICAL TIMING INFO
These commands MUST complete successfully before making changes:

- `flutter doctor` -- Diagnose Flutter installation. NEVER CANCEL. Takes 2-10 minutes on first run. Set timeout to 15+ minutes.
- `flutter pub get` -- Download dependencies. NEVER CANCEL. Takes 1-5 minutes. Set timeout to 10+ minutes.
- `flutter analyze` -- Static analysis. Takes 30 seconds to 2 minutes.
- `flutter test` -- Run unit tests. NEVER CANCEL. Takes 1-3 minutes. Set timeout to 10+ minutes.

### Building the Application
**CRITICAL**: Set long timeouts and NEVER CANCEL these commands:

- `flutter build web` -- Build for web platform. **Takes 5-15 minutes**. NEVER CANCEL. Set timeout to 20+ minutes.
- `flutter build apk` -- Build Android APK. **Takes 10-30 minutes on first build**. NEVER CANCEL. Set timeout to 45+ minutes.
- `flutter build appbundle` -- Build Android App Bundle. **Takes 10-30 minutes**. NEVER CANCEL. Set timeout to 45+ minutes.
- `flutter build ios` -- Build iOS app (macOS only). **Takes 15-45 minutes**. NEVER CANCEL. Set timeout to 60+ minutes.

### Running the Application
- `flutter run -d chrome` -- Run web version in Chrome. Takes 3-8 minutes to start. NEVER CANCEL. Set timeout to 15+ minutes.
- `flutter run -d android` -- Run on Android device/emulator. Takes 5-15 minutes to start. NEVER CANCEL. Set timeout to 20+ minutes.
- `flutter run -d ios` -- Run on iOS simulator (macOS only). Takes 5-15 minutes to start. NEVER CANCEL. Set timeout to 20+ minutes.

### Troubleshooting Common Issues
- **"Flutter command not found"**: Add Flutter bin directory to PATH or reinstall
- **"No devices found"**: For web, ensure Chrome is installed. For Android, start emulator first.
- **Download failures**: Network restrictions may prevent Flutter from downloading dependencies. Try different networks or installation methods.
- **Build failures**: Run `flutter clean` then `flutter pub get` and retry
- **"pub get failed"**: Corporate firewalls may block pub.dev - check network settings

### Repository Validation
Use this quick check to verify repository structure:
```bash
# Verify all required directories exist
ls -la lib/ android/ ios/ web/ test/
# Check key files
ls -la pubspec.yaml analysis_options.yaml lib/main.dart
# Count Dart files (should show 4 files)
find lib -name "*.dart" | wc -l
```

## Validation Requirements

### Manual Testing After Changes
**CRITICAL**: ALWAYS test actual functionality, not just startup:

1. **Basic App Test**: 
   - Run `flutter run -d chrome` (wait for full startup)
   - Navigate to the displayed localhost URL
   - Click the floating "+" button multiple times
   - Verify counter increments from 0 to 1, 2, 3, etc.
   - Take screenshot to verify functionality

2. **Innertube API Test** (if modified):
   - See lib/innertube/README.md for API usage examples
   - Test YouTube search, video info, and recommendations
   - Verify API responses are valid JSON

### Code Quality Checks - REQUIRED BEFORE COMMITS
- `dart format .` -- Format code according to Dart conventions
- `flutter analyze` -- MUST pass with no errors before committing
- `flutter test` -- MUST pass all tests before committing

### Build Validation
Run these after any significant changes:
- `flutter build web --release` -- Ensure web build succeeds
- `flutter build apk --debug` -- Ensure Android build succeeds (if Android changes made)

## Project Dependencies and Structure

### Current Dependencies (from pubspec.yaml)
```yaml
dependencies:
  flutter: sdk
  html_unescape: 2.0.0    # HTML entity decoding
  shared_preferences: 2.5.3  # Local storage
  crypto: 3.0.6           # Cryptographic functions
  toast: 0.3.0            # Toast notifications
  cupertino_icons: ^1.0.8  # iOS-style icons
  http: ^1.3.0            # HTTP requests
  string_unescape: ^2.0.0  # String unescaping

dev_dependencies:
  flutter_test: sdk
  flutter_lints: ^5.0.0   # Code linting rules
```

### Project Structure

### Key Directories and Files
```
/
├── lib/
│   ├── main.dart              # Main application entry point (1,142 total Dart lines)
│   └── innertube/             # YouTube API integration
│       ├── innertube.dart     # Core Innertube client (~500+ lines)
│       ├── youtube.dart       # YouTube-specific methods  
│       ├── constants.dart     # API constants and configurations
│       └── README.md          # Innertube usage documentation
├── android/                   # Android platform code (Kotlin/Gradle)
├── ios/                       # iOS platform code (Swift/Xcode)
├── web/                       # Web platform code (HTML/JS)
├── test/
│   └── widget_test.dart      # Basic widget tests
├── pubspec.yaml              # Flutter dependencies & configuration
└── analysis_options.yaml    # Dart analyzer configuration
```

### Important Files to Monitor
- When modifying `lib/innertube/constants.dart`, always check dependent files in `lib/innertube/`
- Changes to `pubspec.yaml` require running `flutter pub get`
- Platform-specific changes in `android/`, `ios/`, or `web/` may require clean builds

## Common Development Tasks

### Adding Dependencies
1. Add dependency to `pubspec.yaml` under `dependencies:` section
2. Run `flutter pub get` (**2-5 minutes, NEVER CANCEL, timeout 10+ minutes**)
3. Import in Dart files: `import 'package:package_name/package_name.dart';`
4. Run `flutter analyze` to check for issues

### Making Code Changes  
1. Edit Dart files in `lib/` directory
2. Use hot reload during `flutter run` for instant changes (press 'r' in terminal)
3. For structural changes, stop and restart `flutter run`

### Debugging and Development
- `flutter logs` -- View device logs in real-time
- `flutter inspector` -- Widget debugging (with IDE support)
- Chrome DevTools -- Available for web debugging at chrome://inspect
- `flutter clean` -- Clean build cache when builds fail mysteriously

### Platform-Specific Development
- **Android**: Edit files in `android/` directory, may require Gradle sync in Android Studio
- **iOS**: Edit files in `ios/` directory, may require Xcode project updates  
- **Web**: Edit files in `web/` directory for web-specific configurations

## Important Development Guidelines

### File Monitoring and Dependencies
- When modifying `lib/innertube/constants.dart`, ALWAYS check these dependent files:
  - `lib/innertube/innertube.dart`
  - `lib/innertube/youtube.dart`
- Changes to `pubspec.yaml` ALWAYS require `flutter pub get`
- Platform-specific changes require platform-specific builds to test

### Performance and Timing Expectations
- **First-time setup**: Can take 30+ minutes including Flutter installation
- **Cold builds**: 15-45 minutes depending on platform
- **Hot reload during development**: 1-3 seconds  
- **Subsequent builds**: 2-10 minutes (cached)
- **Tests**: Usually complete in 1-3 minutes

## Known Issues and Limitations

### Current Application State
- **Template Status**: Currently a basic Flutter counter app template
- **Innertube Integration**: YouTube API client exists but not yet integrated into UI  
- **Platform Support**: Configured for Android, iOS, and Web but needs platform-specific testing
- **Codebase Size**: 4 Dart files totaling ~1,142 lines of code

### Development Constraints  
- **Network Dependencies**: Flutter commands require internet access for package downloads
- **Build Dependencies**: First builds download significant toolchain components (can be 1GB+)
- **API Limitations**: YouTube Innertube API may require proper user agents and rate limiting
- **Environment Issues**: Some corporate/restricted networks may block Flutter package downloads

### Common Problems and Solutions
- **"Target of URI doesn't exist"**: Run `flutter pub get` to download missing packages
- **"No connected devices"**: For web, install Chrome; for mobile, setup emulators/devices
- **Long build times**: Normal for Flutter, especially first builds - wait patiently
- **Hot reload not working**: Restart `flutter run` or make a structural change
- **"Waiting for connection from debug service"**: Normal startup behavior, wait 2-5 minutes
- **"Failed to download Dart SDK"**: Network issue, try different installation method or network

## Repository Status and Information
- **Primary branch**: `dev` (default development branch)  
- **Dependencies**: Managed via `pubspec.yaml`, locked in `pubspec.lock`
- **Code quality**: Enforced via `analysis_options.yaml` (flutter_lints package)
- **CI/CD**: No GitHub Actions workflows currently configured
- **Platform targets**: OpenHarmony, Android, iOS (as stated in README)
- **API Integration**: Custom Innertube implementation for YouTube data access

## Quick Reference Commands
Copy-paste these for quick development workflow:
```bash
# Initial setup
flutter doctor
flutter pub get
flutter analyze  
flutter test

# Development  
flutter run -d chrome          # Web development
flutter run -d android         # Android development  

# Pre-commit checks
dart format .
flutter analyze
flutter test

# Builds
flutter build web --release
flutter build apk --debug
```

**Remember**: Always use long timeouts (10+ minutes) for build commands and NEVER CANCEL long-running operations.