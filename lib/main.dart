import 'package:flutter/material.dart';
import 'pages/train_page.dart';
import 'pages/prediction_page.dart';
import 'dart:async';
import 'package:camera/camera.dart';

Future<void> main() async {
// Ensure that plugin services are initialized so that `availableCameras()`
// can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

// Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

// Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(FacialRecognition(firstCamera: firstCamera));
}

class FacialRecognition extends StatelessWidget {
  final CameraDescription firstCamera;

  FacialRecognition({required this.firstCamera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Facial Recognition',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MainPage(
        title: 'Flutter Demo Home Page',
        camera: firstCamera,
      ),
      routes: {
        '/train': (context) => TrainPage(),
        '/prediction': (context) => PredictionPage(),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title, required this.camera});
  final String title;
  final CameraDescription camera;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/train');
              },
              child: Text('Train'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/prediction');
              },
              child: Text('Predict'),
            ),
          ],
        ),
      ),
    );
  }
}
