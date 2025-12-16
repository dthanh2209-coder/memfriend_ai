# MemFriend AI

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.9+-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.9+-0175C2?logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg)

**An intelligent memory management app with face recognition technology**

[Features](#-features) • [Installation](#-installation) • [Usage](#-usage) • [Architecture](#-architecture) • [Contributing](#-contributing)

</div>

---

## About

**MemFriend AI** is a Flutter-based mobile application that helps you manage and organize memories associated with people using advanced face recognition technology. The app allows you to store memories, recognize faces in real-time, and retrieve information about people you've met before.

### Key Highlights

- 🤖 **AI-Powered Face Recognition**: Real-time face detection and matching using native machine learning
- 📸 **Memory Management**: Store and organize memories with photos and descriptions
- 🔊 **Voice Pronunciation**: Text-to-speech feature to pronounce recognized names
- 🌐 **Multi-language Support**: Available in English and Vietnamese
- 🔒 **Privacy-First**: All data is stored locally on your device, no cloud sync required

---

## Features

### 1. **Person Management**
- Create, update, and delete person profiles
- Store face data for each person
- Manage profile images

### 2. **Real-time Face Recognition**
- Live camera preview with face detection
- Automatic person identification
- Voice pronunciation of recognized names
- Support for unknown face detection

### 3. **Memory Events**
- Add memory events with photos and descriptions
- Link memories to specific people
- View memory timeline for each person
- Edit and delete memories

### 4. **Settings & Localization**
- Switch between English and Vietnamese
- App information and version details
- Privacy policy and data security information

---

## Technology Stack

### Core Framework
- **Flutter** 3.9+ - Cross-platform UI framework
- **Dart** 3.9+ - Programming language

### State Management & Routing
- **GetX** 4.7+ - State management, routing, and dependency injection

### Database & Storage
- **SQLite** (sqflite) - Local database for Person and MemoryEvent data
- **path_provider** - File system access
- **shared_preferences** - App settings storage

### Image Processing
- **image_picker** - Camera and gallery access
- **image** - Image manipulation and processing
- **camera** - Real-time camera preview

### AI & Machine Learning
- **Native Face Recognition Engine** (vifacecore.aar) - Face detection and matching
- Face detection and recognition model files

### Additional Features
- **flutter_tts** - Text-to-speech for name pronunciation
- **permission_handler** - Runtime permissions management
- **intl** - Internationalization and date formatting

---

## Project Structure

```
lib/
├── app/
│   ├── modules/
│   │   ├── home/              # Home screen module
│   │   │   ├── controllers/
│   │   │   ├── views/
│   │   │   └── bindings/
│   │   ├── recognition/       # Face recognition module
│   │   │   ├── controllers/
│   │   │   ├── views/
│   │   │   └── bindings/
│   │   ├── add_memory/        # Add memory module
│   │   │   ├── controllers/
│   │   │   ├── views/
│   │   │   └── bindings/
│   │   └── settings/          # Settings module
│   │       ├── controllers/
│   │       ├── views/
│   │       └── bindings/
│   └── routes/                # App routing
├── core/
│   ├── theme/                 # App theming
│   ├── values/                # App strings & localization
│   └── utils/                 # Utility functions
├── data/
│   ├── models/                # Data models (Person, MemoryEvent)
│   ├── providers/             # Database helper
│   └── services/              # Business logic services
│       ├── storage_service.dart
│       ├── face_recognition_service.dart
│       └── tts_service.dart
└── main.dart                  # App entry point
```

### Architecture

The app follows a **layered architecture** pattern with GetX:

- **Presentation Layer**: UI components and views
- **Controller Layer**: State management and business logic
- **Service Layer**: Data operations and external integrations
- **Data Layer**: Local storage (SQLite, File System, SharedPreferences)
- **Native Layer**: Camera and face recognition engine

For detailed architecture documentation, see [docs/architecture_summary.md](docs/architecture_summary.md)

---

## Installation

### Prerequisites

- **Flutter SDK** 3.9.0 or higher
- **Dart SDK** 3.9.0 or higher
- **Android Studio** / **VS Code** with Flutter extensions
- **Android SDK** (for Android development)
- **Xcode** (for iOS development, macOS only)

### Step 1: Install Flutter

1. Download Flutter SDK from the [official website](https://docs.flutter.dev/get-started/install)
2. Extract the downloaded file to your desired location
3. Add Flutter to your system `PATH` environment variable
4. Run `flutter doctor` to check for required dependencies and install any missing components

### Step 2: Clone the Repository

```bash
git clone <repository-url>
cd memfriend_ai
```

### Step 3: Install Dependencies

```bash
flutter pub get
```

### Step 4: Setup Native Dependencies

#### Android

1. Ensure you have the native face recognition library (`vifacecore.aar`) in `android/app/libs/`
2. Place face recognition model files:
   - `face_detection.param` → `android/app/src/main/res/detect/`
   - `face_recognize.param` → `android/app/src/main/res/recognize/`

#### iOS (if applicable)

1. Configure iOS permissions in `ios/Runner/Info.plist`
2. Add required capabilities for camera access

### Step 5: Run the App

#### Debug Mode

```bash
flutter run
```

#### Release Mode (Android APK)

```bash
flutter build apk --release
```

The APK will be generated at: `build/app/outputs/flutter-apk/app-release.apk`

#### Release Mode (iOS)

```bash
flutter build ios --release
```

---

## 📱 Usage

### Getting Started

1. **Launch the App**: Open MemFriend AI on your device
2. **Grant Permissions**: Allow camera and storage permissions when prompted
3. **Add a Person**: 
   - Navigate to Home screen
   - Tap "Add Person" button
   - Take a photo or select from gallery
   - Enter person's name
   - Save the person profile

4. **Recognize Faces**:
   - Go to Recognition screen
   - Point camera at a person
   - The app will detect and identify if the person exists in your database
   - If recognized, the app will display person info and pronounce the name

5. **Add Memory Events**:
   - Select a person from Home screen
   - Tap "Add Memory" button
   - Take or select a photo
   - Enter memory description
   - Save the memory event

### Key Features Usage

#### Face Recognition
- Open the Recognition screen
- Point your camera at a person's face
- The app automatically detects and matches faces
- Recognized persons are highlighted with their information

#### Memory Management
- View all memories in the Home screen
- Filter memories by person
- Edit or delete existing memories
- View memory timeline for each person

#### Settings
- Change app language (English/Vietnamese)
- View app information and version
- Read privacy policy

---

## Development

### Running Tests

```bash
flutter test
```

### Code Analysis

```bash
flutter analyze
```

### Building for Different Platforms

#### Android APK
```bash
flutter build apk --release
```

#### Android App Bundle
```bash
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

### Debugging

- Use `flutter run` with your IDE's debugger
- Check logs with `flutter logs`
- Use Flutter DevTools for performance profiling

---

## Database Schema

### Person Table
- `id` (INTEGER PRIMARY KEY)
- `name` (TEXT)
- `faceData` (TEXT) - Face feature embeddings
- `imagePath` (TEXT) - Profile image path
- `createdTime` (TEXT)
- `updatedTime` (TEXT)

### MemoryEvent Table
- `id` (INTEGER PRIMARY KEY)
- `personId` (INTEGER FOREIGN KEY)
- `name` (TEXT)
- `content` (TEXT) - Optional description
- `imagePath` (TEXT)
- `createdTime` (TEXT)
- `updatedTime` (TEXT)

---

## Permissions

The app requires the following permissions:

### Android
- `CAMERA` - For taking photos and face recognition
- `READ_EXTERNAL_STORAGE` - For accessing gallery images
- `WRITE_EXTERNAL_STORAGE` - For saving images
- `RECORD_AUDIO` - For text-to-speech functionality
- `INTERNET` - For future features (optional)

---

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Development Guidelines

- Follow Flutter/Dart style guidelines
- Write meaningful commit messages
- Add comments for complex logic
- Update documentation as needed
- Test your changes thoroughly

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Documentation



---

## Known Issues

- Face recognition accuracy may vary depending on lighting conditions
- Large image files may affect app performance
- Some features may require additional native library setup

---

## Future Enhancements

- [ ] Cloud backup and sync
- [ ] Advanced search and filtering
- [ ] Memory sharing features
- [ ] Export memories as PDF
- [ ] Multiple face recognition models
- [ ] Enhanced analytics and insights

---

## Contact & Support

### Development Team

For questions, suggestions, or support, please contact:

- **Email**: [Your Email Address]
- **GitHub Issues**: [Create an issue](https://github.com/dthanh2209-coder/memfriend_ai/issues)

### Video Tutorial

📹 **Demo Video**: [YouTube Link - Coming Soon]

Watch our video tutorial to see MemFriend AI in action:
- App overview and features
- Installation guide
- Usage walkthrough
- Tips and tricks

<!-- 
TODO: Add YouTube video link when available
Example: [![Demo Video](https://img.youtube.com/vi/VIDEO_ID/0.jpg)](https://www.youtube.com/watch?v=VIDEO_ID)
-->

### Authors

**Development Team**
- [Vu Duc Thanh] - [Core Infrastructure & Home Module] - [https://github.com/dthanh2209-coder]
- [Vo Huu Minh Tri] - [Memory Management & Settings & Android Platform] - [https://github.com/VHMTri1502]
- [Ngo Bao Chau] - [Data Layer & Person Management] - [https://github.com/NgoChau1312]
- [Le Khac Anh Duc] - [Face Recognition & AI] - [https://github.com/AnhDuck2307]


---

<div align="center">

**Made with ❤️ using Flutter**

⭐ Star this repo if you find it helpful!

</div>
