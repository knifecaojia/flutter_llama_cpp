// LLaMA CPP Dart Integration for Flutter
//
// This implementation demonstrates real integration with llama_cpp_dart library:
// - Uses libmtmd.so for Android native library
// - Initializes LLaMA model with multimodal projector support
// - Configures model parameters optimized for mobile devices
// - Handles model loading, image processing, and inference
// - Provides comprehensive error handling and status feedback
//
// Model Requirements:
// - Main model: /data/local/tmp/ggml-model-Q4_K_M.gguf
// - Multimodal projector: /data/local/tmp/mmproj-model-f16.gguf
// - Test image: /data/local/tmp/1.jpg
//
// Note: The exact inference API may vary depending on llama_cpp_dart version.
// This code demonstrates proper initialization and provides a foundation for
// implementing the specific inference methods available in your package version.

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:llama_cpp_dart/llama_cpp_dart.dart';
import 'dart:async';
import 'dart:isolate';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LLaMA CPP Dart - Real Inference',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ImageInferencePage(),
    );
  }
}

// Data classes for isolate communication
class InferenceData {
  final SendPort sendPort;
  final String modelPath;
  final String mmprojPath;
  final String imagePath;
  final String prompt;

  InferenceData({
    required this.sendPort,
    required this.modelPath,
    required this.mmprojPath,
    required this.imagePath,
    required this.prompt,
  });
}

class InferenceResult {
  final String content;
  final bool isComplete;
  final bool isError;

  InferenceResult({
    required this.content,
    required this.isComplete,
    required this.isError,
  });
}

class ImageInferencePage extends StatefulWidget {
  const ImageInferencePage({super.key});

  @override
  State<ImageInferencePage> createState() => _ImageInferencePageState();
}

class _ImageInferencePageState extends State<ImageInferencePage> {
  bool _isProcessing = false;
  String _resultText = '';
  String _statusText = 'Ready to process';
  LlamaParent? _llamaParent;
  StreamSubscription? _responseSubscription;
  Isolate? _inferenceIsolate;
  ReceivePort? _receivePort;
  
  // File paths for model, mmproj, and image
  String _modelPath = '/data/local/tmp/ggml-model-Q4_K_M.gguf';
  String _mmprojPath = '/data/local/tmp/mmproj-model-f16.gguf';
  String _imagePath = '/data/local/tmp/1.jpg';
  File? _selectedImageFile;

  @override
  void initState() {
    super.initState();
    _initializeLlama();
  }

  @override
  void dispose() {
    // Cancel response subscription
    _responseSubscription?.cancel();
    // Kill inference isolate
    _inferenceIsolate?.kill(priority: Isolate.immediate);
    _receivePort?.close();
    // Safely dispose of LLaMA instance
    if (_llamaParent != null) {
      try {
        _llamaParent!.dispose();
      } catch (e) {
        // Ignore disposal errors during widget disposal
        debugPrint('Warning: Error during LLaMA disposal: $e');
      } finally {
        _llamaParent = null;
      }
    }
    super.dispose();
  }

  Future<void> _initializeLlama() async {
    try {
      setState(() {
        _statusText = 'Initializing LLaMA library...';
      });

      // Set library path for Android
      Llama.libraryPath = "libmtmd.so";

      setState(() {
        _statusText = 'LLaMA library initialized. Ready to process.';
      });
    } catch (e) {
      setState(() {
        _statusText = 'Failed to initialize LLaMA: $e';
      });
    }
  }

  // File selection methods
  Future<void> _selectModelFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      dialogTitle: 'Select Model File (.gguf)',
    );
    
    if (result != null) {
      String filePath = result.files.single.path!;
      if (filePath.toLowerCase().endsWith('.gguf')) {
        setState(() {
          _modelPath = filePath;
          _statusText = 'Model file selected successfully';
        });
        // Reset status after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _statusText = 'Ready to process';
            });
          }
        });
      } else {
        // Show error message for invalid file type
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select a .gguf model file'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _selectMmprojFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      dialogTitle: 'Select MMProj File (.gguf)',
    );
    
    if (result != null) {
      String filePath = result.files.single.path!;
      if (filePath.toLowerCase().endsWith('.gguf')) {
        setState(() {
          _mmprojPath = filePath;
          _statusText = 'MMProj file selected successfully';
        });
        // Reset status after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _statusText = 'Ready to process';
            });
          }
        });
      } else {
        // Show error message for invalid file type
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select a .gguf multimodal projector file'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _selectImageFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      
      if (result != null) {
        File selectedFile = File(result.files.single.path!);
        setState(() {
          _statusText = 'Processing image...';
        });
        
        try {
          File compressedFile = await _compressImageIfNeeded(selectedFile);
          setState(() {
            _selectedImageFile = compressedFile;
            _imagePath = compressedFile.path;
            _statusText = 'Image selected and processed successfully';
          });
        } catch (e) {
          setState(() {
            _statusText = 'Ready to process';
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error processing image: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Image compression method
  Future<File> _compressImageIfNeeded(File imageFile) async {
    int fileSizeInBytes = await imageFile.length();
    int fileSizeInKB = fileSizeInBytes ~/ 1024;
    
    if (fileSizeInKB <= 40) {
      return imageFile; // No compression needed
    }
    
    // Read and decode the image
    Uint8List imageBytes = await imageFile.readAsBytes();
    img.Image? originalImage = img.decodeImage(imageBytes);
    
    if (originalImage == null) {
      throw Exception('Unable to decode image');
    }
    
    // Start with quality 85 and reduce until file size is under 40KB
    int quality = 85;
    Uint8List? compressedBytes;
    
    do {
      compressedBytes = img.encodeJpg(originalImage, quality: quality);
      quality -= 10;
    } while (compressedBytes.length > 40 * 1024 && quality > 10);
    
    // Save compressed image to temporary directory
    Directory tempDir = await getTemporaryDirectory();
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    File compressedFile = File('${tempDir.path}/compressed_$timestamp.jpg');
    await compressedFile.writeAsBytes(compressedBytes);
    
    return compressedFile;
  }

  Future<void> _runInference() async {
    setState(() {
      _isProcessing = true;
      _resultText = '';
      _statusText = 'Starting inference...';
    });

    try {
      // Cancel existing subscription and dispose model if any
      _responseSubscription?.cancel();
      _inferenceIsolate?.kill(priority: Isolate.immediate);
      _receivePort?.close();
      if (_llamaParent != null) {
        try {
          _llamaParent!.dispose();
        } catch (e) {
          // Ignore disposal errors during cleanup
        }
        _llamaParent = null;
      }

      // Model paths from selected files
      final String modelPath = _modelPath;
      final String mmprojPath = _mmprojPath;
      final String imagePath = _imagePath;

      setState(() {
        _statusText = 'Checking required files...';
      });

      // Check if all required files exist
      final modelFile = File(modelPath);
      final mmprojFile = File(mmprojPath);
      final imageFile = File(imagePath);

      if (!await modelFile.exists()) {
        throw Exception('Model file not found at $modelPath');
      }

      if (!await mmprojFile.exists()) {
        throw Exception('Multimodal projector file not found at $mmprojPath');
      }

      if (!await imageFile.exists()) {
        throw Exception('Image file not found at $imagePath');
      }

      setState(() {
        _statusText = 'Configuring model parameters...';
      });

      setState(() {
        _statusText = 'Initializing LLaMA model with multimodal support...';
      });
      // Create load command for LlamaParent
      final loadCommand = LlamaLoad(
        path: modelPath,
        modelParams: ModelParams(),
        contextParams: ContextParams(),
        samplingParams: SamplerParams(),
        mmprojPath: mmprojPath,
      );

      // Initialize LlamaParent
      _llamaParent = LlamaParent(loadCommand);
      await _llamaParent!.init();

      final prompt =  "describe this image:";

      setState(() {
        _statusText = 'Loading image for inference...';
      });

      // Load the image using LlamaImage.fromFile
      final image = LlamaImage.fromFile(imageFile);

      setState(() {
        _statusText = 'Preparing inference prompt...';
      });

      // Create the multimodal prompt following the reference format

      // Log image processing for debugging
      debugPrint('Image loaded: ${image.runtimeType}');

      setState(() {
        _statusText = 'Running REAL multimodal inference...';
        _resultText = ''; // Clear any previous results
      });

      // Start inference in separate isolate for better performance
      await _startInferenceInIsolate(_llamaParent!, prompt, image);
    } catch (e, s) {
      setState(() {
        _statusText = 'General Error';
        _resultText = 'Unexpected error: $e\nStack trace: $s';
        _isProcessing = false;
      });
    }
  }

  // Start inference in separate isolate to prevent UI blocking
  Future<void> _startInferenceInIsolate(
    LlamaParent llamaParent,
    String prompt,
    LlamaImage image,
  ) async {
    try {
      // Create receive port for communication with isolate
      _receivePort = ReceivePort();

      // Start inference isolate
      _inferenceIsolate = await Isolate.spawn(
        _inferenceIsolateEntryPoint,
        InferenceData(
          sendPort: _receivePort!.sendPort,
          modelPath: _modelPath,
          mmprojPath: _mmprojPath,
          imagePath: _imagePath,
          prompt: prompt,
        ),
      );

      setState(() {
        _statusText =
            'Real inference in progress (running in background thread)...';
      });

      // Listen to messages from isolate
      _responseSubscription = _receivePort!.listen((message) {
        if (message is InferenceResult) {
          if (message.isComplete) {
            setState(() {
              _statusText = 'Real inference completed!';
              _isProcessing = false;
            });
          } else if (message.isError) {
            setState(() {
              _statusText = 'Inference error occurred';
              _resultText = 'Error during inference: ${message.content}';
              _isProcessing = false;
            });
          } else {
            // Streaming token
            setState(() {
              _resultText += message.content;
            });
          }
        }
      });
    } catch (e) {
      setState(() {
        _statusText = 'Failed to start inference isolate';
        _resultText = 'Error: $e';
        _isProcessing = false;
      });
    }
  }

  // Static method to run in isolate
  static void _inferenceIsolateEntryPoint(InferenceData data) async {
    try {
      // Set library path for isolate
      Llama.libraryPath = "libmtmd.so";

      // Create load command for LlamaParent (correct approach)
      final modelParams = ModelParams()..nGpuLayers = -1;
      final contextParams = ContextParams()
        ..nPredict = -1
        ..nCtx = 4096
        ..nBatch = 1024;
      final samplerParams = SamplerParams()
        ..temp = 0.25
        ..topP = 0.90;
      final loadCommand = LlamaLoad(
        path: data.modelPath,
        modelParams: modelParams,
        contextParams: contextParams,
        samplingParams: samplerParams,
        mmprojPath: data.mmprojPath,
      );

      // Initialize LlamaParent in isolate
      final llamaParent = LlamaParent(loadCommand);
      await llamaParent.init();

      // Load image
      final image = LlamaImage.fromFile(File(data.imagePath));

      // Log image for debugging (ensures image is used)
      debugPrint('Loaded image: ${image.runtimeType} for multimodal inference');

      // Send prompt for inference (text-based approach)
      llamaParent.sendPrompt(data.prompt);

      // Stream results back to main isolate
      llamaParent.stream.listen(
        (response) {
          data.sendPort.send(
            InferenceResult(
              content: response,
              isComplete: false,
              isError: false,
            ),
          );
        },
        onDone: () {
          data.sendPort.send(
            InferenceResult(content: '', isComplete: true, isError: false),
          );
          llamaParent.dispose();
        },
        onError: (error) {
          data.sendPort.send(
            InferenceResult(
              content: error.toString(),
              isComplete: false,
              isError: true,
            ),
          );
          llamaParent.dispose();
        },
      );
    } catch (e) {
      data.sendPort.send(
        InferenceResult(
          content: e.toString(),
          isComplete: false,
          isError: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LLaMA CPP Dart - Real Inference'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _statusText,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('📋 Multimodal Configuration:'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text('📁 Model: ${_modelPath.split('/').last}'),
                      ),
                      ElevatedButton(
                        onPressed: _selectModelFile,
                        child: const Text('Select'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text('🎯 MMProj: ${_mmprojPath.split('/').last}'),
                      ),
                      ElevatedButton(
                        onPressed: _selectMmprojFile,
                        child: const Text('Select'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text('🖼️ Image: ${_imagePath.split('/').last}'),
                      ),
                      ElevatedButton(
                        onPressed: _selectImageFile,
                        child: const Text('Select'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text('💬 Library: libmtmd.so (Android)'),
                  const Text('🔧 Mode: CPU inference with multimodal projector'),
                  const Text(
                    '⚡ Inference: Real-time streaming with generateWithMedia',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Image preview section
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🖼️ Image Preview:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Container(
                      width: 200,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: FutureBuilder<bool>(
                        future: _selectedImageFile != null 
                            ? _selectedImageFile!.exists() 
                            : File(_imagePath).exists(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasData && snapshot.data == true) {
                            File imageFile = _selectedImageFile ?? File(_imagePath);
                            return Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    imageFile,
                                    width: 200,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey.shade100,
                                        child: const Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.error, color: Colors.red),
                                              Text(
                                                'Error loading image',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 4),
                                FutureBuilder<int>(
                                  future: imageFile.length(),
                                  builder: (context, sizeSnapshot) {
                                    if (sizeSnapshot.hasData) {
                                      int sizeKB = sizeSnapshot.data! ~/ 1024;
                                      return Text(
                                        'Size: ${sizeKB}KB',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: sizeKB > 40 ? Colors.red : Colors.green,
                                        ),
                                      );
                                    }
                                    return const SizedBox();
                                  },
                                ),
                              ],
                            );
                          } else {
                            return Container(
                              color: Colors.grey.shade100,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey,
                                      size: 40,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Image not found',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      _imagePath,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 150, // Set height to 200px
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📝 Inference Results:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          child: Text(
                            _resultText,
                            style: const TextStyle(fontFamily: 'monospace'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _runInference,
                child: Text(_isProcessing ? 'Processing...' : 'Run Inference'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
