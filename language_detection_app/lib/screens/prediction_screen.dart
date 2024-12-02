import 'package:flutter/material.dart';
import '../services/api_service.dart';

class PredictionScreen extends StatefulWidget {
  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final ApiService apiService =
      ApiService(baseUrl: 'https://language-dectection-summative.onrender.com');
  final TextEditingController _controller = TextEditingController();
  String _predictionResult = '';
  bool _isLoading = false;

  Future<void> _getPrediction() async {
    if (_controller.text.trim().isEmpty) {
      setState(() {
        _predictionResult = 'Please enter a sentence for prediction.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _predictionResult = '';
    });

    try {
      List<String> sentences = [_controller.text.trim()];
      final response = await apiService.predict(sentences);
      setState(() {
        _predictionResult = 'Predicted Language: ${response['predictions'][0]}';
      });
    } catch (e) {
      setState(() {
        _predictionResult = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language Detection'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/retrain');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter text for prediction...',
                border: OutlineInputBorder(),
                hintText: 'e.g., Hola, ¿cómo estás?',
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getPrediction,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                ),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Predict Language',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
            SizedBox(height: 16),
            if (_predictionResult.isNotEmpty)
              Text(
                _predictionResult,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
