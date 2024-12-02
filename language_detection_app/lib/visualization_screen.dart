import 'package:flutter/material.dart';

class VisualizationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dataset Visualizations'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Dataset Insights',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Image.asset(
                'assets/dataset_visualizations.png',
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16),
              Text(
                'These visualizations provide insights into the dataset, such as language distribution, average word count per language, and text length distribution. Use this information to improve model understanding and feature selection.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
