import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  // Predict endpoint: Sends text data for language detection
  Future<Map<String, dynamic>> predict(List<String> sentences) async {
    final response = await http.post(
      Uri.parse('$baseUrl/predict'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'sentences': sentences}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Parse the response
    } else {
      throw Exception('Failed to load prediction');
    }
  }

  // Retrain endpoint: Uploads a new dataset for retraining
  Future<Map<String, dynamic>> retrain(Map<String, String> filePath) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/retrain'),
    );
    request.files
        .add(await http.MultipartFile.fromPath('file', filePath['file']!));

    var response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      return jsonDecode(responseBody);
    } else {
      throw Exception('Failed to retrain the model');
    }
  }
}
