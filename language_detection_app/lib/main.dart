import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import 'screens/prediction_screen.dart';
import 'visualization_screen.dart';
import 'screens/retrain_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LingoPredict',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/prediction': (context) => PredictionScreen(),
        '/retrain': (context) => RetrainScreen(),
        '/visualization': (context) =>
            VisualizationScreen(), // Register the route
      },
    );
  }
}
