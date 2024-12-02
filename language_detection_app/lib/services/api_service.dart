import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:html' as html;

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
        // Create a Blob from the response body
        final blob = html.Blob([response.bodyBytes]);

        // Create a URL for the Blob
        final url = html.Url.createObjectUrlFromBlob(blob);

        // Create an anchor element and trigger a download
        final anchor = html.AnchorElement(href: url)
          ..target = 'blank'
          ..download =
              'retrained_model.keras'; // Specify the name of the file to download

        // Trigger the download by clicking the anchor element
        anchor.click();

        // Clean up the URL after the download
        html.Url.revokeObjectUrl(url);

        print('Model download started');
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
