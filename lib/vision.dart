import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  String data = "Evaluating the scene";
  Timer?  _timer;
  final gemini = Gemini.instance;
  final FlutterTts flutterTts = FlutterTts();

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("ne-NP");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
    setState(() {
      data = text;
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    _initializeCamera();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
     _analyze();
    });
  }

  Future<void> _initializeCamera() async {
    // Fetch available cameras
    _cameras = await availableCameras();

    if (_cameras!.isNotEmpty) {
      // Initialize the first camera
      _cameraController = CameraController(
        _cameras![0], // Select the first camera (back camera)
        ResolutionPreset.high,
      );

      // Initialize the camera controller and start the camera preview
      await _cameraController!.initialize();

      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _analyze() async {
    try {
      String path = await _takePicture();
      var file = File(path);
      gemini
          .textAndImage(
              text:
                  "You are guiding a blind person this is what the person sees. Formulate appropriate response. and navigate where to go next, make them aware of any pitfalls as well as dangers, keep the response extremely short in nepali language.",
              images: [file.readAsBytesSync()])
          .then((value) => {_speak(value?.content?.parts?.last.text??' ')})
          .catchError((e) => throw "Error");
    } catch (e) {
      setState(() {
        data = e.toString();
      });
    }
  }

  Future<String> _takePicture() async {
    if (!_cameraController!.value.isInitialized) {
      throw "Error: not initialized camera";
    }

    try {
      // Ensure the camera is not currently taking a picture
      if (_cameraController!.value.isTakingPicture) {
        throw "Error: not taking picture";
      }

      // Capture a picture and save it to a file
      XFile picture = await _cameraController!.takePicture();
      return picture.path;
    } catch (e) {
      throw 'Error taking picture: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vision'),
      ),
      body: Column(
        children: [
          if (_isCameraInitialized)
            Expanded(
              child: AspectRatio(
                aspectRatio: _cameraController!.value.aspectRatio,
                child: CameraPreview(_cameraController!),
              ),
            )
          else
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            ),
          const SizedBox(height: 20),
          Text(data),
        ],
      ),
    );
  }
}
