import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../models/prediction_model.dart';
import '../services/http_client_service.dart'; // Import the camera plugin

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
      ),
      body: _controller != null
          ? FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;

            final image = await _controller.takePicture();

            if (!mounted) return;

            final imageBytes = File(image.path).readAsBytesSync();

            final base64string = base64Encode(imageBytes);

            final predictionModel = PredictionModel(base64string: base64string);

            final content = jsonEncode(predictionModel.toJson());

            final response =
                await HttpClientService().Predict(content, 'Prediction/upload');

            print(response.statusCode);

            // Handle the API response as needed
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
