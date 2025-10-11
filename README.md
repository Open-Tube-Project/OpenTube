# OpenTube

[![Flutter](https://img.shields.io/badge/Flutter-Cross%20Platform-blue)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-Language-blue)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-Open%20Source-green)](#license)

OpenTube is a powerful, open-source third-party YouTube client designed to bring YouTube to all major operating systems platforms: **OpenHarmony**, **Android**, and **iOS**. Built with Flutter, OpenTube provides a seamless video streaming experience across multiple platforms while offering enhanced features and customization options.

## 🌟 Features

- **Cross-Platform Support**: Native support for OpenHarmony, Android, and iOS
- **YouTube API Integration**: Advanced InnerTube API implementation for reliable video access
- **Enhanced Video Experience**: 
  - SponsorBlock integration for automatic sponsor segment skipping
  - Return YouTube Dislike support
  - Multiple video quality options
  - Thumbnail support in various resolutions
- **Smart Search**: Auto-completion and advanced search functionality
- **Recommendation Engine**: Personalized video recommendations
- **Continuation Support**: Seamless infinite scrolling for search results and recommendations

## 🚀 Quick Start

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (>=3.35.4)
- [Dart SDK](https://dart.dev/get-dart) (>=3.35.4)
- Platform-specific development tools:
  - **Android**: Android Studio or VS Code with Android SDK
  - **iOS**: Xcode (macOS only)
  - **OpenHarmony**: DevEco Studio

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Open-Tube-Project/OpenTube.git
   cd OpenTube
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   # For Android
   flutter run -d android
   
   # For iOS (macOS only)
   flutter run -d ios
   ```

## 📱 Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Android | ✅ Supported | Full feature support |
| iOS | ✅ Supported | Full feature support |
| OpenHarmony | 🚧 In Development | Core features available |

## 🛠️ Architecture

OpenTube is built using a modular architecture with the following key components:

- **InnerTube API**: Core YouTube API integration (`lib/innertube/`)
- **UI Layer**: Flutter-based user interface (`lib/main.dart`)
- **Platform Integration**: Native platform-specific implementations

For detailed API documentation, see [InnerTube Documentation](lib/innertube/README.md).

## 🤝 Contributing

We welcome contributions from the community! Please read our [Contributing Guidelines](CONTRIBUTING.md) before submitting pull requests.

### Development Setup

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes and test thoroughly
4. Commit your changes: `git commit -m 'Add amazing feature'`
5. Push to the branch: `git push origin feature/amazing-feature`
6. Open a Pull Request

## 📖 Documentation

- [API Documentation](lib/innertube/README.md) - InnerTube API usage and examples
- [Contributing Guidelines](CONTRIBUTING.md) - How to contribute to the project
- [Code of Conduct](CODE_OF_CONDUCT.md) - Community guidelines
- [Changelog](CHANGELOG.md) - Project history and updates

## 🔒 Privacy & Security

OpenTube respects user privacy and does not collect personal data. The application:
- Uses YouTube's public APIs
- Does not store user credentials
- Operates entirely client-side
- Supports anonymous usage

## 🐛 Troubleshooting

### Common Issues

**Build Errors**
- Ensure Flutter SDK is properly installed and up to date
- Run `flutter doctor` to check for configuration issues
- Clear Flutter cache: `flutter clean && flutter pub get`

**API Issues**
- Check network connectivity
- Verify YouTube is accessible in your region
- Report persistent API issues in the [Issues](https://github.com/Open-Tube-Project/OpenTube/issues) section

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/Open-Tube-Project/OpenTube/issues)
- **Discussions**: [GitHub Discussions](https://github.com/Open-Tube-Project/OpenTube/discussions)
- **Wiki**: [Project Wiki](https://github.com/Open-Tube-Project/OpenTube/wiki)

## 📄 License

This project is open source and available under the [AGPL License](https://www.gnu.org/licenses/agpl-3.0.en.html).

## 🙏 Acknowledgments

- Flutter team for the amazing cross-platform framework
- YouTube InnerTube API for video access
- SponsorBlock community for sponsor detection
- Return YouTube Dislike for engagement metrics
- All contributors who make this project possible

## 🗺️ Roadmap

- [ ] OpenHarmony platform completion
- [ ] Enhanced video player features
- [ ] Offline video support
- [ ] Advanced customization options
- [ ] Performance optimizations

---

**Made with ❤️ by the Open-Tube-Project community**
