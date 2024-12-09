import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<Map<String, dynamic>> predict(List<String> sentences) async {
    final response = await http.post(
      Uri.parse('$baseUrl/predict'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'sentences': sentences}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load prediction');
    }
  }

  Future<Map<String, dynamic>> retrainWithBytes(Uint8List fileBytes) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/retrain'),
    );

    request.files.add(http.MultipartFile.fromBytes(
      'file',
      fileBytes,
      filename: 'uploaded_file.csv', // Specify a file name
    ));

    var response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      return jsonDecode(responseBody);
    } else {
      throw Exception('Failed to retrain the model');
    }
  }

  Future<void> downloadModel(String downloadUrl) async {
    try {
      final response = await http.get(Uri.parse(downloadUrl));

      if (response.statusCode == 200) {
        // Get the directory to save the file
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/retrained_model.keras';

        // Write the file
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        print('Model downloaded to $filePath');
      } else {
        throw Exception(
            'Failed to download model. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading model: $e');
      throw Exception('Failed to download model');
    }
  }
}
