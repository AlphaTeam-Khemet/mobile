# 🏺 KHEMET: GEM Smart Guide 🏛️

<p align="center">
  <em>Your AI-powered Egyptian Museum companion.</em>
</p>

---

## 📖 Overview
**KHEMET** is a cutting-edge Flutter mobile application designed to revolutionize the visitor experience at the Grand Egyptian Museum (GEM). By seamlessly integrating advanced Artificial Intelligence capabilities—such as conversational chatbots, real-time hieroglyph translation, and interactive tours—KHEMET serves as an immersive and intelligent digital tour guide for exploring Egypt's rich historical legacy.

## ✨ Key Features
- **🔑 Secure Authentication**: Robust user onboarding featuring sign-in, registration, and email verification workflows.
- **🗺️ Interactive Tours**: Dynamic home dashboards and engaging guided tour experiences.
- **🤖 Khemet AI Chatbot**: A deeply integrated, intelligent companion capable of answering intricate queries about ancient Egypt and specific museum artifacts.
- **📸 Scan & Translate**: Utilize the device camera to scan hieroglyphs or physical artifacts, delivering real-time translations and rich historical context.
- **📚 Curated Collections**: Browse extensive artifact catalogs, view high-resolution details, and manage personalized favorite lists.
- **🌍 Localization**: Full multi-language support ensuring accessibility for a diverse, global audience.
- **⚙️ Profile & Settings**: Comprehensive user profile management, customizable app preferences, and seamless state persistence.

## 🛠 Tech Stack
- **Framework**: [Flutter](https://flutter.dev/) (SDK ^3.8.1)
- **Language**: [Dart](https://dart.dev/)
- **Networking**: `dio` (for robust API requests), `cached_network_image`, `url_launcher`
- **Media & Hardware APIs**: `camera`, `image_picker`, `video_player`, `audioplayers`, `photo_manager`
- **State & Storage**: `shared_preferences`
- **System**: `permission_handler`
- **UI & Assets**: `flutter_svg`, `cupertino_icons`, Material 3 Design

## 📂 Architecture & Directory Structure
The codebase follows a modular, feature-based architecture ensuring scalability and maintainability:

```text
lib/
├── auth/            # Authentication flows (Sign In, Register, Verification)
├── chat/            # Khemet AI Chatbot interfaces and logic
├── core/            # Core utilities (Dio client, API config, service classes)
├── details/         # Artifact details, collections, favorites, profile, and settings
├── forgot_password/ # Forgot password, OTP verification, and reset password flows
├── home/            # Primary dashboards and tour initiation pages
├── localization/    # Multi-language support and dynamic language switching
├── main_tab_home/   # Main bottom navigation and tab routing logic
├── onboarding/      # Splash screens and first-time user experiences
├── shared_widgets/  # Reusable, cross-feature UI components
├── translate/       # Camera scanning and AI translation result pages
├── widgets/         # App-specific custom UI elements
└── main.dart        # Application entry point & initialization
```

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK**: `^3.8.1` or higher.
- **Dart SDK**: Compatible with the Flutter version.
- **IDE**: Android Studio, VS Code, or IntelliJ IDEA with Flutter plugins installed.
- **Environment**: A connected physical device or emulator (Android/iOS).

### Installation & Setup
1. **Navigate to the mobile directory**:
   ```bash
   cd /path/to/Khemet/mobile
   ```

2. **Fetch Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the Application**:
   ```bash
   flutter run
   ```

## 🧩 Design Patterns & State Management
- **Modular Design**: Features are encapsulated in their respective directories (`auth`, `chat`, `details`), decoupling business logic from UI elements.
- **Local Persistence**: `shared_preferences` handles caching authentication tokens (`auth_token`) and user preferences locally.
- **Material 3**: Fully embraces Flutter's Material 3 design system for a modern, responsive, and platform-adaptive UI.
- **Asynchronous Initialization**: `main.dart` ensures all necessary bindings, localization files, and local states are fully loaded before rendering the application tree.

## 🤝 Contributing
1. Fork the repository.
2. Create your feature branch (`git checkout -b feature/AmazingFeature`).
3. Commit your changes (`git commit -m 'feat: add some AmazingFeature'`).
4. Push to the branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request detailing your changes.

## 📄 License
This project is proprietary and built for the KHEMET Graduation Project. All rights reserved.
