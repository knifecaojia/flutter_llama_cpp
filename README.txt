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

## 📱 Screenshots

The app provides an intuitive interface with:
- Configuration panel showing selected files
- Image preview with size information
- Real-time inference results with scrollable output
- File selection buttons for easy model and data management

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Android Studio or VS Code with Flutter extensions
- Android device or emulator (API level 21+)
- LLaMA model files in GGUF format

### Required Model Files

You'll need the following files for the app to work:

1. **Main Model**: A LLaMA model in GGUF format (e.g., `ggml-model-Q4_K_M.gguf`)
2. **Multimodal Projector**: A vision projector file (e.g., `mmproj-model-f16.gguf`)
3. **Test Image**: Any image file for testing (automatically compressed if > 40KB)

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/llama-cpp-flutter.git
   cd llama-cpp-flutter
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Build the app**:
   ```bash
   flutter build apk
   ```

4. **Install on device**:
   ```bash
   flutter install
   ```

### Model Setup

1. Download compatible LLaMA models:
   - Main model: Any GGUF format LLaMA model
   - Multimodal projector: Compatible vision projector file

2. Use the app's file selection feature to choose your model files
   - Tap "Select" next to "Model" to choose your GGUF model file
   - Tap "Select" next to "MMProj" to choose your multimodal projector
   - Tap "Select" next to "Image" to choose an image for inference

## 🛠️ Technical Architecture

### Core Components

- **Main App**: Single-file Flutter application (`lib/main.dart`)
- **Isolate Processing**: Background inference to prevent UI blocking
- **File Management**: Dynamic file selection and validation
- **Image Processing**: Automatic compression and optimization

### Key Technologies

- **Framework**: Flutter 3.x
- **Language**: Dart
- **AI Library**: llama_cpp_dart
- **Image Processing**: image package
- **File Picking**: file_picker package
- **Storage**: path_provider package

### Performance Optimizations

- **Mobile-optimized Parameters**: Reduced context size and batch size for mobile devices
- **CPU-only Inference**: Optimized for Android CPU processing
- **Automatic Image Compression**: Keeps images under 40KB for efficient processing
- **Background Processing**: Uses Dart isolates to prevent UI freezing

## 📋 Usage Instructions

1. **Launch the App**: Open the app on your Android device

2. **Select Model Files**:
   - Tap "Select" next to "Model" to choose your GGUF model file
   - Tap "Select" next to "MMProj" to choose your multimodal projector file
   - Tap "Select" next to "Image" to choose an image for analysis

3. **Run Inference**:
   - Tap "Run Inference" button
   - Watch as the AI analyzes the image and generates a description
   - Results appear in real-time in the scrollable output area

4. **View Results**:
   - Scroll through the inference results
   - The output shows the AI's description of the selected image

## 🎯 Supported File Formats

- **Models**: `.gguf` format (LLaMA CPP compatible)
- **Images**: `.jpg`, `.png`, `.bmp`, `.gif` and other standard formats
- **Automatic Compression**: Images over 40KB are automatically compressed

## 🔧 Configuration

### Model Parameters

The app uses mobile-optimized parameters:
- Context size: 1024 tokens
- Batch size: 128 for efficient processing
- CPU-only inference for Android compatibility
- Quality-based image compression

### Customization

You can modify the following in `lib/main.dart`:
- Model parameters (context size, batch size)
- Image compression settings
- UI layout and styling
- Prompt format for different use cases

## 🐛 Troubleshooting

### Common Issues

1. **File Not Found Errors**:
   - Ensure model files are properly selected using the file picker
   - Check that selected files exist and are accessible

2. **Memory Issues**:
   - Use quantized models (Q4_K_M recommended)
   - Reduce context size if needed
   - Ensure sufficient device RAM

3. **Slow Inference**:
   - Use smaller models for faster processing
   - Reduce image resolution
   - Check device CPU capabilities

4. **App Crashes**:
   - Verify model file compatibility
   - Check device specifications
   - Review error logs for specific issues

### Debug Mode

Enable debug logging by:
1. Building in debug mode: `flutter run --debug`
2. Check console output for detailed error information
3. Use `adb logcat` for Android-specific logs

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/your-feature`
3. **Make your changes**: Follow the existing code style
4. **Test thoroughly**: Ensure your changes work on different devices
5. **Submit a pull request**: Describe your changes clearly

### Development Guidelines

- Follow Flutter best practices
- Add comments for complex logic
- Test on multiple Android devices
- Update documentation for new features
- Maintain backward compatibility when possible

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **MiniCPM Team & OpenBMB (面壁智能)**: Special thanks to the OpenBMB team for their outstanding MiniCPM multimodal models and their dedication to open-source AI. Their innovative work on efficient multimodal language models has made mobile AI inference possible and accessible to developers worldwide.
- **LLaMA Team**: For the amazing language models
- **llama.cpp Project**: For the C++ implementation
- **llama_cpp_dart**: For Dart bindings
- **Flutter Team**: For the excellent mobile framework
- **Open Source Community**: For inspiration and support

## 📞 Support

- **Issues**: Report bugs and request features on GitHub Issues
- **Discussions**: Join discussions in GitHub Discussions
- **Documentation**: Check the wiki for detailed guides
- **Community**: Connect with other developers using this project

## 🔄 Changelog

### Version 1.0.0
- Initial release
- Basic multimodal inference support
- File selection interface
- Automatic image compression
- Real-time streaming results
- Isolate-based processing

## 🎯 Roadmap

- [ ] iOS support
- [ ] Multiple model format support
- [ ] Batch image processing
- [ ] Model downloading interface
- [ ] Performance benchmarking tools
- [ ] Voice input support
- [ ] Export/import configuration

## 📚 Resources

- [LLaMA Official Page](https://ai.facebook.com/blog/large-language-model-llama-meta-ai/)
- [llama.cpp GitHub](https://github.com/ggerganov/llama.cpp)
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Guide](https://dart.dev/guides)

---

Made with ❤️ for the AI and Flutter communities