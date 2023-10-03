import 'package:flutter/material.dart';
import 'pages/train_page.dart';
import 'pages/prediction_page.dart';

void main() {
  runApp(const FacialRecognition());
}

class FacialRecognition extends StatelessWidget {
  const FacialRecognition({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Facial Recognition',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage(title: 'Flutter Demo Home Page'),
      routes: {
        '/train': (context) => TrainPage(),
        '/prediction': (context) => PredictionPage(),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});
  final String title;

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
