import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../models/prediction_model.dart';
import '../services/http_client_service.dart';
import '../widgets/image_dialog.dart';

class PredictionPage extends StatefulWidget {
  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }

  void _toggleCamera() async {
    if (_controller != null) {
      CameraLensDirection newDirection =
          _controller.description.lensDirection == CameraLensDirection.back
              ? CameraLensDirection.front
              : CameraLensDirection.back;
      final cameras = await availableCameras();
      final newCamera =
          cameras.firstWhere((camera) => camera.lensDirection == newDirection);
      await _controller.dispose();
      _controller = CameraController(
        newCamera,
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controller.initialize();
      setState(() {});
    }
  }

  void _handleUsePicture(File imageFile) async {
    Navigator.pop(context);
    try {
      final imageBytes = await imageFile.readAsBytes();
      final base64string = base64Encode(imageBytes);
      final predictionModel = PredictionModel(base64string: base64string);
      final content = jsonEncode(predictionModel.toJson());
      final response =
          await HttpClientService().Predict(content, 'Prediction/upload');
      print(response.statusCode);
      // Handle the API response as needed
    } catch (e) {
      print('Error: $e');
      // Handle errors that occur during the process
    }
  }

  void _handleRetakePicture() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prediction Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.switch_camera),
            onPressed: _toggleCamera,
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return GestureDetector(
                  onTap: () {
                    // Handle onTap event for CameraPreview
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height *
                        1, // Set the desired height
                    child: CameraPreview(_controller),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          Positioned(
            bottom: 16,
            child: ClipOval(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    try {
                      await _initializeControllerFuture;
                      final image = await _controller.takePicture();
                      if (!mounted) return;
                      final imageFile = File(image.path);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ImageDialog(
                            imageFile: imageFile,
                            onUsePressed: () {
                              _handleUsePicture(imageFile);
                            },
                            onRetakePressed: _handleRetakePicture,
                          );
                        },
                      );
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                    ),
                    child: Icon(Icons.camera_alt, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
