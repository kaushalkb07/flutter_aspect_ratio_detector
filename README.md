# 📸 Aspect Ratio Flutter App

A Flutter mobile app to calculate and display the **aspect ratio** of images or videos, either from local gallery or from an internet URL. Built using **MVVM architecture**, and supports both **Android** and **iOS** platforms.

---

## ✨ Features

- 📷 Pick images or videos from gallery
- 🌐 Load media via direct URL
- 📐 Calculates and displays:
  - Dimensions (e.g. `1920 x 1080`)
  - Aspect ratio (e.g. `1.78`)
- ▶️ Video preview using [`chewie`](https://pub.dev/packages/chewie)
- 🎯 MVVM architecture (Clean separation of logic and UI)

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2
  image_picker: ^1.1.0
  video_player: ^2.8.1
  chewie: ^1.12.1
  http: ^1.2.1
  path_provider: ^2.1.2
  path: ^1.9.0


---

## 🚀 Getting Started

1. Clone this repository:
    ```bash
    git clone https://github.com/kaushalkb07/ride_sharing_app.git
    cd ride_sharing_app
    ```
2. Install dependencies:
    ```bash
    flutter pub get
    ```
3. Run the app:
    ```bash
    flutter run
    ```
