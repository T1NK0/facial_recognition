import 'package:flutter/material.dart';
import 'pages/prediction_page.dart';
import 'dart:async';
import 'package:camera/camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
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
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Color(
            0xFF4CAF50), // Light green color as primary color for dark mode
        colorScheme: ColorScheme.dark(
            primary: Color(0xFF4CAF50)), // Dark theme color scheme
      ),
      debugShowCheckedModeBanner: false,
      themeMode:
          ThemeMode.system, // Set ThemeMode.dark for dark mode by default
      home: MainPage(
        title: 'Flutter Demo Home Page',
        camera: firstCamera,
      ),
      routes: {
        '/prediction': (context) => PredictionPage(),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title, required this.camera})
      : super(key: key);
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/Machine_Learning_Facial_Recognition_surveillance_soc.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(
                top: 250.0), // You can adjust the top padding as needed
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/prediction');
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed))
                    return Colors.white.withOpacity(
                        0.5); // Semi-transparent white when pressed
                  return Colors.white
                      .withOpacity(0.3); // Semi-transparent white
                }),
                foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.white), // Black text color
              ),
              child: Text('Predict'),
            ),
          ),
        ),
      ),
    );
  }
}
