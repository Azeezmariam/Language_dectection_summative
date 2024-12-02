import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import '../services/api_service.dart';

class RetrainScreen extends StatefulWidget {
  @override
  _RetrainScreenState createState() => _RetrainScreenState();
}

class _RetrainScreenState extends State<RetrainScreen> {
  final ApiService apiService =
      ApiService(baseUrl: 'https://language-dectection-summative.onrender.com');
  String? _fileName;
  Uint8List? _fileBytes;
  Map<String, dynamic>? _metrics;
  String _retrainResult = '';
  String? _modelDownloadUrl;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
        _fileBytes = result.files.single.bytes;
      });
    } else {
      setState(() {
        _retrainResult = 'No file selected.';
      });
    }
  }

  Future<void> _retrainModel() async {
    if (_fileBytes == null) {
      setState(() {
        _retrainResult = 'No file selected for retraining.';
      });
      return;
    }

    try {
      var response = await apiService.retrainWithBytes(_fileBytes!);
      setState(() {
        if (response.containsKey('metrics')) {
          _metrics = response['metrics'];
        } else {
          _metrics = null;
        }
        _modelDownloadUrl = response['model_download_url'];
        _retrainResult =
            response['detail'] ?? 'Retraining completed successfully!';
      });
    } catch (e) {
      setState(() {
        _retrainResult = 'Error retraining model: $e';
      });
    }
  }

  void _downloadModel() async {
    if (_modelDownloadUrl != null) {
      final downloadUrl = 'http://127.0.0.1:8000${_modelDownloadUrl!}';

      setState(() {
        _retrainResult = 'Downloading model...';
      });

      try {
        await apiService.downloadModel(downloadUrl);
        setState(() {
          _retrainResult = 'Model downloaded successfully!';
        });
      } catch (e) {
        setState(() {
          _retrainResult = 'Error downloading model: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Retrain Model')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _pickFile,
              child: Text('Pick File for Retraining'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              ),
            ),
            SizedBox(height: 16),
            Text(_fileName != null
                ? 'Selected: $_fileName'
                : 'No file selected'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _retrainModel,
              child: Text('Retrain Model'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              ),
            ),
            SizedBox(height: 16),
            if (_metrics != null) ...[
              Text('Evaluation Metrics:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Accuracy: ${_metrics!['accuracy']}'),
              Text('Precision: ${_metrics!['precision']}'),
              Text('Recall: ${_metrics!['recall']}'),
              Text('F1 Score: ${_metrics!['f1_score']}'),
            ] else if (_retrainResult.isNotEmpty) ...[
              Text(_retrainResult),
            ],
            SizedBox(height: 16),
            if (_modelDownloadUrl != null) ...[
              ElevatedButton(
                onPressed: _downloadModel,
                child: Text('Download Retrained Model'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
