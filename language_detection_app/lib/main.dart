import 'package:flutter/material.dart';
import 'services/api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Language Detection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PredictionScreen(),
    );
  }
}

class PredictionScreen extends StatefulWidget {
  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final ApiService apiService =
      ApiService(baseUrl: 'https://language-dectection-summative.onrender.com');
  final TextEditingController _controller = TextEditingController();
  String _predictionResult = '';

  // Function to handle prediction
  void _getPrediction() async {
    try {
      List<String> sentences = [_controller.text];
      final response = await apiService.predict(sentences);
      setState(() {
        _predictionResult = 'Predicted Language: ${response['predictions'][0]}';
      });
    } catch (e) {
      setState(() {
        _predictionResult = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Language Detection')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter a sentence for prediction',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getPrediction,
              child: Text('Get Prediction'),
            ),
            SizedBox(height: 16),
            Text(_predictionResult),
          ],
        ),
      ),
    );
  }
}
