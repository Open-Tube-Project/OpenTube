# Contributing to OpenTube

Thank you for your interest in contributing to OpenTube! This document provides guidelines and information for contributors.

## 🤝 How to Contribute

### Reporting Issues

Before creating an issue, please:

1. **Search existing issues** to avoid duplicates
2. **Use a clear, descriptive title** that summarizes the problem
3. **Provide detailed information** including:
   - Steps to reproduce the issue
   - Expected vs. actual behavior
   - Platform/device information
   - Flutter/Dart version
   - Screenshots or error logs (if applicable)

### Suggesting Features

We welcome feature suggestions! Please:

1. **Check if the feature already exists** or is planned
2. **Create a detailed proposal** including:
   - Use case and benefits
   - Proposed implementation approach
   - Potential challenges or considerations
   - Mock-ups or examples (if applicable)

### Code Contributions

#### Getting Started

1. **Fork the repository**
   ```bash
   git clone https://github.com/Open-Tube-Project/OpenTube.git
   cd OpenTube
   ```

2. **Set up development environment**
   ```bash
   flutter pub get
   flutter doctor  # Verify setup
   ```

3. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

#### Development Guidelines

**Code Style**
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `dart format` to format your code
- Run `dart analyze` to check for issues
- Maintain consistent naming conventions

**Testing**
- Write unit tests for new functionality
- Ensure existing tests pass: `flutter test`
- Test on multiple platforms when possible
- Include integration tests for UI changes

**Documentation**
- Update relevant documentation
- Add inline comments for complex logic
- Update API documentation for new methods
- Include usage examples where appropriate

#### Pull Request Process

1. **Ensure your code is ready**
   ```bash
   dart format .
   dart analyze
   flutter test
   ```

2. **Create a meaningful commit message**
   ```
   feat: add video quality selection
   
   - Implement quality selector dropdown
   - Add quality persistence with SharedPreferences
   - Update video player to respect quality setting
   
   Closes #123
   ```

3. **Push your changes**
   ```bash
   git push origin feature/your-feature-name
   ```

4. **Create a Pull Request**
   - Use a clear, descriptive title
   - Reference related issues with `Closes #issue-number`
   - Provide detailed description of changes
   - Include screenshots for UI changes
   - Request review from maintainers

## 📋 Development Setup

### Prerequisites

- **Flutter SDK**: >= 3.7.0
- **Dart SDK**: >= 3.7.0
- **Platform Tools**:
  - Android: Android Studio or VS Code with Android SDK
  - iOS: Xcode (macOS only)
  - OpenHarmony: DevEco Studio

### Environment Setup

1. **Clone and setup**
   ```bash
   git clone https://github.com/Open-Tube-Project/OpenTube.git
   cd OpenTube
   flutter pub get
   ```

2. **Verify installation**
   ```bash
   flutter doctor -v
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Project Structure

```
OpenTube/
├── lib/
│   ├── main.dart                 # App entry point
│   └── innertube/               # YouTube API integration
│       ├── constants.dart       # API constants and configurations
│       ├── innertube.dart      # Core InnerTube API implementation
│       ├── youtube.dart        # Enhanced YouTube functionality
│       └── README.md           # InnerTube API documentation
├── test/                       # Unit and widget tests
├── android/                    # Android platform files
├── ios/                       # iOS platform files
├── web/                       # Web platform files
└── docs/                      # Additional documentation
```

### Coding Standards

#### Dart/Flutter Guidelines

```dart
// Good: Clear, descriptive names
class VideoPlayer {
  Future<void> loadVideoData(String videoId) async {
    // Implementation
  }
}

// Good: Proper error handling
try {
  final result = await apiCall();
  return result;
} catch (e) {
  logger.error('Failed to load data: $e');
  rethrow;
}

// Good: Consistent formatting
final videoData = await innertube.getVidAsync(videoId);
if (videoData['success']) {
  return VideoModel.fromJson(videoData['data']);
}
```

#### API Integration Guidelines

```dart
// Good: Robust error handling for API calls
Future<ApiResponse<VideoData>> getVideoInfo(String videoId) async {
  try {
    final response = await innertube.getVidAsync(videoId);
    
    if (response['success']) {
      return ApiResponse.success(VideoData.fromJson(response['data']));
    } else {
      return ApiResponse.error('Failed to load video: ${response['message']}');
    }
  } catch (e) {
    return ApiResponse.error('Network error: $e');
  }
}
```

## 🧪 Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/innertube_test.dart

# Run tests with coverage
flutter test --coverage
```

### Writing Tests

```dart
// Example unit test
import 'package:flutter_test/flutter_test.dart';
import 'package:opentube/innertube/innertube.dart';

void main() {
  group('InnerTube API Tests', () {
    late Innertube innertube;

    setUp(() async {
      innertube = await Innertube.createAsync(null);
    });

    test('should get video recommendations', () async {
      final result = await innertube.getRecommendationsAsync();
      expect(result['success'], isTrue);
      expect(result['data'], isNotNull);
    });
  });
}
```

## 🚀 Release Process

### Version Management

We follow [Semantic Versioning](https://semver.org/):
- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

### Changelog

Update `CHANGELOG.md` with:
- New features
- Bug fixes
- Breaking changes
- Dependencies updates

## 📖 Documentation

### Code Documentation

```dart
/// Retrieves video information from YouTube API.
/// 
/// [videoId] must be a valid YouTube video ID (11 characters).
/// 
/// Returns a [Future] that completes with video data or throws
/// an exception if the video cannot be found.
/// 
/// Example:
/// ```dart
/// final videoData = await getVideoInfo('dQw4w9WgXcQ');
/// print('Title: ${videoData['title']}');
/// ```
Future<Map<String, dynamic>> getVideoInfo(String videoId) async {
  // Implementation
}
```

### README Updates

When adding new features, update:
- Feature list in main README.md
- Usage examples
- API documentation
- Platform compatibility notes

## 🐛 Debugging

### Common Issues

**Build Errors**
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

**Platform-Specific Issues**
```bash
# Android
flutter build apk --debug
adb logcat | grep flutter

# iOS
flutter build ios --debug
```

**API Debugging**
```dart
// Enable detailed logging
Innertube.createAsync((message, isError, [shortMessage]) {
  print('[${isError ? 'ERROR' : 'INFO'}] $message');
  if (shortMessage != null) {
    print('Short: $shortMessage');
  }
});
```

## 🔒 Security Guidelines

### API Keys and Secrets

- **Never commit** API keys or secrets
- Use environment variables for sensitive data
- Review code for hardcoded credentials before submitting

### User Privacy

- Respect user privacy in all implementations
- Follow platform privacy guidelines
- Document data collection practices

## 📞 Community

### Communication Channels

- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: General questions and community discussions
- **Pull Requests**: Code contributions and reviews

### Code of Conduct

Please read and follow our [Code of Conduct](CODE_OF_CONDUCT.md) to ensure a welcoming environment for all contributors.

## 🏆 Recognition

Contributors are recognized in:
- GitHub contributors page
- Release notes for significant contributions
- Special mentions for major features or fixes

Thank you for contributing to OpenTube! Your efforts help make this project better for everyone. 🎉