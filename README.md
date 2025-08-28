# LLaMA CPP Flutter - Local Multimodal AI Inference

A Flutter application demonstrating local multimodal AI inference using LLaMA CPP on Android devices. This project showcases how to run large language models with image understanding capabilities directly on mobile devices without requiring cloud services.

## 🌟 Features

- **Local AI Inference**: Run LLaMA models directly on Android devices
- **Multimodal Support**: Process both text and images for comprehensive AI understanding
- **File Selection**: Easy-to-use interface for selecting model files, multimodal projectors, and images
- **Automatic Image Compression**: Automatically compresses images to 40KB for optimal performance
- **Real-time Streaming**: See inference results appear in real-time as they're generated
- **Offline Capability**: No internet connection required for inference
- **Isolate-based Processing**: Non-blocking UI during inference operations

## 🚀 Quick Start

### Prerequisites

- Flutter SDK (3.0 or higher)
- Android Studio or VS Code with Flutter extensions
- Android device or emulator (API level 21+)
- LLaMA model files in GGUF format

### Installation

1. Clone this repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Build the app:
   ```bash
   flutter build apk
   ```
4. Install on device:
   ```bash
   flutter install
   ```

## 📱 Usage

1. **Select Model Files**: Use the file selection buttons to choose:
   - Main model (.gguf format)
   - Multimodal projector (.gguf format) 
   - Image for analysis (automatically compressed if > 40KB)

2. **Run Inference**: Tap "Run Inference" to start the AI analysis

3. **View Results**: Real-time results appear in the scrollable output area

## 🛠️ Technical Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **AI Library**: llama_cpp_dart
- **Image Processing**: image package
- **File Management**: file_picker, path_provider

## 📋 Supported Formats

- **Models**: .gguf format (LLaMA CPP compatible)
- **Images**: .jpg, .png, .bmp, .gif and other standard formats
- **Auto-compression**: Images over 40KB are automatically optimized

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License.

## 🙏 Acknowledgments

- **MiniCPM Team & OpenBMB (面壁智能)**: Special thanks to the OpenBMB team for their outstanding MiniCPM multimodal models and their dedication to open-source AI. Their innovative work on efficient multimodal language models has made mobile AI inference possible and accessible to developers worldwide.
- LLaMA Team for the amazing language models
- llama.cpp project for the C++ implementation
- llama_cpp_dart for Dart bindings
- Flutter team for the excellent framework