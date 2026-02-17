# Avico Smart 🌿

Avico Smart is a sophisticated **Agritech IoT Monitoring Solution** designed to provide real-time environment data for modern farming. Built using **Flutter**, it integrates seamlessly with **Blynk IoT Platform** and **Firebase** to offer a robust, cross-platform experience.

## ✨ Key Features

- **Real-Time Monitoring**: Track Temperature, Humidity, $CO_2$, and Nitrogen levels directly via Blynk IoT integration.
- **Interactive Data Visualization**: Sophisticated charts and gauges (powered by `fl_chart` and `sf_gauges`) to analyze environmental trends.
- **Cloud Integration**: Secure user authentication and data management powered by Firebase.
- **Modern UI/UX**: A clean, professional interface built with Google Fonts and optimized for different resolutions.
- **Global Reach**: Cross-platform support for Android, iOS, Windows, and macOS.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev) (SDK: ^3.9.2)
- **IoT Backend**: [Blynk IoT](https://blynk.io)
- **Cloud Backend**: [Firebase](https://firebase.google.com) (Auth, Core)
- **State Management**: [GetX](https://pub.dev/packages/get)
- **Styling**: Google Fonts (Outfit/Roboto), Custom Gauge Widgets

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable version recommended)
- Blynk IoT Account and Virtual Pins setup
- Firebase Project setup

### Configuration

1. **Blynk Setup**:
   - Update your Blynk Auth Token in `lib/core/constants/api_config.dart`.
   - Ensure your virtual pins (`v1`, `v2`, `v3`, `v4`) match your device configuration.

2. **Firebase Setup**:
   - Update your Firebase credentials in `lib/firebase_options.dart`.
   - Download and place your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) in the respective platform directories if not using FlutterFire configuration.

### Installation

```bash
# Clone the repository
git clone https://github.com/your-username/avico_smart.git

# Navigate to project directory
cd avico_smart

# Install dependencies
flutter pub get

# Run the application
flutter run
```

## 📱 Screenshots

*(Add your high-quality project screenshots here)*

---

*Developed with ❤️ for the future of Agriculture.*
