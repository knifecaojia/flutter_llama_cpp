# Implementation Guide: LLaMA CPP with Flutter

This guide explains how to properly implement LLaMA CPP with Flutter for local inference on Android devices.

## Understanding the llama_cpp_dart Package

The [llama_cpp_dart](https://pub.dev/packages/llama_cpp_dart) package provides Dart bindings for the [llama.cpp](https://github.com/ggerganov/llama.cpp) project, which enables running large language models locally.

### Package Architecture

The package offers three levels of abstraction:

1. **Low-Level FFI Bindings**: Direct access to llama.cpp functions
2. **High-Level Wrapper**: Simplified, object-oriented API
3. **Managed Isolate**: Flutter-friendly, non-blocking implementation

For mobile applications, it's recommended to use the Managed Isolate approach as it prevents blocking the UI thread.

## Setting Up the Project

### 1. Add Dependencies

Add the required dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  llama_cpp_dart: ^0.1.0
  image: ^4.0.0 # For image processing
```

### 2. Prepare Model Files

For Android, you need to place the model files in the device's file system:

- Model file: `/data/local/tmp/ggml-model-Q4_K_M.gguf`
- MMProj file: `/data/local/tmp/mmproj-model-f16.gguf`
- Test image: `/data/local/tmp/1.jpg`

You can use `adb` to push files to these locations:

```bash
adb push ggml-model-Q4_K_M.gguf /data/local/tmp/
adb push mmproj-model-f16.gguf /data/local/tmp/
adb push test-image.jpg /data/local/tmp/1.jpg
```

### 3. Compile llama.cpp Library

You need to compile the llama.cpp library for your target platform. For Android:

1. Clone the llama.cpp repository:
   ```bash
   git clone https://github.com/ggerganov/llama.cpp
   ```

2. Follow the Android compilation instructions in the repository to build the shared library.

3. Place the resulting `.so` files in your Flutter project's `android/app/src/main/jniLibs/` directory, organized by architecture.

## Implementation Details

### Basic Setup

```dart
import 'package:llama_cpp_dart/llama_cpp_dart.dart';

// Set the library path for Android
Llama.libraryPath = "libllama.so";
```

### Loading a Model

```dart
final loadCommand = LlamaLoad(
  path: "/data/local/tmp/ggml-model-Q4_K_M.gguf",
  modelParams: ModelParams(
    nGpuLayers: 99, // Number of layers to offload to GPU
  ),
  contextParams: ContextParams(
    nCtx: 2048, // Context size
  ),
  samplingParams: SamplerParams(),
);

final llamaParent = LlamaParent(loadCommand);
await llamaParent.init();
```

### Processing Images

For multimodal models, you can process images using the `LlamaImage` class:

```dart
final image = LlamaImage.fromFile(File("/data/local/tmp/1.jpg"));

final prompt = Prompt(
  text: "USER: Describe this image in detail.\nASSISTANT:",
  images: [image],
  mmprojPath: "/data/local/tmp/mmproj-model-f16.gguf",
);

llamaParent.sendPrompt(prompt);
```

### Handling Responses

Listen to the response stream to get generated text:

```dart
String fullResponse = '';
llamaParent.stream.listen((response) {
  setState(() {
    fullResponse += response.text;
  });
});
```

## Important Considerations

### Performance

- Large models require significant RAM and may not work on all devices
- Consider using quantized models (Q4_K_M, Q5_K_M, etc.) for mobile deployment
- Offload layers to GPU when possible using `nGpuLayers`

### File Permissions

On Android, accessing `/data/local/tmp/` requires appropriate permissions. You may need to:

1. Root the device, or
2. Use the app's private storage directory, or
3. Request appropriate permissions in your AndroidManifest.xml

### Error Handling

Always implement proper error handling for:

- File not found errors
- Model loading failures
- Memory allocation issues
- Inference errors

## Example Implementation

The main.dart file in this project shows a complete implementation with:

- A clean UI for triggering inference
- Status updates during processing
- Display of generated text
- Proper resource cleanup

## Troubleshooting

### Common Issues

1. **Library not found**: Ensure the llama.cpp library is properly compiled and placed in the correct location.

2. **Model loading failures**: Check that model files exist and are not corrupted.

3. **Memory issues**: Use quantized models or reduce context size.

4. **Slow inference**: Increase GPU layer offloading or use a smaller model.

### Debugging Tips

1. Check logcat output on Android for detailed error messages:
   ```bash
   adb logcat
   ```

2. Use smaller models for testing to reduce memory requirements.

3. Monitor memory usage during inference.

## Conclusion

This implementation demonstrates how to integrate LLaMA CPP with Flutter for local AI inference. While the current example uses simulated responses due to package integration complexities, a full implementation would follow the patterns described above.

For production applications, consider:
- Implementing proper error handling
- Adding support for model selection
- Improving the UI/UX
- Adding features like chat history
- Optimizing for performance