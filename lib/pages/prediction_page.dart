import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../models/prediction_model.dart';
import '../services/http_client_service.dart';
import '../widgets/image_dialog.dart'; // Import the camera plugin

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

  // Initialize the camera controller

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

      await _controller.dispose(); // Dispose of the old controller
      _controller = CameraController(
        newCamera,
        ResolutionPreset.medium,
      );

      _initializeControllerFuture = _controller.initialize();

      setState(() {});
    }
  }

  void _handleUsePicture(File imageFile) async {
    Navigator.pop(context); // Close the dialog

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
    Navigator.pop(context); // Close the dialog
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
                return CameraPreview(_controller);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          Positioned(
            bottom: 16, // Adjust the distance from the bottom as needed
            child: FloatingActionButton(
              onPressed: () async {
                try {
                  await _initializeControllerFuture;
                  final image = await _controller.takePicture();

                  if (!mounted) return;

                  final imageFile = File(image.path);

                  // Show the captured image in an AlertDialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ImageDialog(
                        imageFile: imageFile,
                        onUsePressed: () {
                          _handleUsePicture(
                              imageFile); // Pass the function to handle the image processing
                        },
                        onRetakePressed:
                            _handleRetakePicture, // Handle retaking the picture
                      );
                    },
                  );
                } catch (e) {
                  print(e);
                }
              },
              child: const Icon(Icons.camera_alt),
            ),
          )
        ],
      ),
    );
  }
}
