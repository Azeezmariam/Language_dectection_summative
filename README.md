# README for LingoPredict App

---

## Table of Contents
1. [Introduction](#introduction)  
2. [Features](#features)  
3. [Technologies Used](#technologies-used)  
4. [Dataset Overview](#dataset-overview)  
5. [App Structure](#app-structure)  
6. [How to Use](#how-to-use)  
7. [Visualizations](#visualizations)  
8. [Setup and Installation](#setup-and-installation)  
9. [API Documentation](#api-documentation)  
10. [Future Enhancements](#future-enhancements)  

---

## Introduction
LingoPredict is a language prediction and retraining application designed to analyze East African languages. This app enables users to predict language classes, retrain the model with new data, and view insights through visualizations. It empowers organizations in the tourism sector to bridge language barriers.

---

## Features
1. **Language Prediction**: Predict the language category based on the input.  
2. **Model Retraining**: Upload a dataset to retrain the model, ensuring relevance with updated language data.  
3. **Model Metrics**: View metrics like accuracy, precision, recall, and F1-score after retraining.  
4. **Download Retrained Model**: Save the updated model locally.  
5. **Visualizations**: Gain insights into the dataset with interactive visualizations.  

---

## Technologies Used
- **Frontend**: Flutter  
- **Backend**: FastAPI  
- **Programming Languages**: Dart, Python  
- **Visualization Libraries**: Matplotlib, Seaborn  
- **Database**: CSV-based data processing  
- **Libraries/Plugins**:
  - Flutter: `http`, `path_provider`, `file_picker`, `flutter_svg`
  - Python: `pandas`, `numpy`, `matplotlib`, `seaborn`, `scikit-learn`

---

## Dataset Overview
The dataset includes fields for `Text`, `Language`, and `Confidence` scores. It provides labeled examples for predicting and classifying East African languages.

### Sample Fields:
- **Text**: Sentence or phrase in a specific language.
- **Language**: Predicted language class (e.g., Swahili, English).
- **Confidence**: A score denoting model prediction confidence.

---

## App Structure

### Flutter File Structure:
lib/ ├── main.dart ├── screens/ │ ├── welcome_screen.dart │ ├── prediction_screen.dart │ ├── retrain_screen.dart │ ├── visualization_screen.dart ├── services/ │ ├── api_service.dart ├── assets/ ├── welcome_image.png


### Key Flutter Components:
- **Welcome Screen**: Entry point for app navigation.
- **Prediction Screen**: Enables users to predict language from input.
- **Retrain Screen**: Allows retraining and downloading the updated model.
- **Visualization Screen**: Displays dataset insights.

---

## How to Use

### **Language Prediction**
1. Navigate to the **Prediction Screen**.
2. Enter a sentence or phrase.
3. Click "Predict" to see the detected language.

### **Model Retraining**
1. Go to the **Retrain Screen**.
2. Upload a `.csv` dataset.
3. View updated metrics and download the retrained model.

### **Visualizations**
1. Navigate to the **Visualization Screen**.
2. Explore charts and gain insights into key dataset features.

---

## Visualizations

The app includes visualizations for:
1. **Language Distribution**: A bar chart showing the frequency of each language.
2. **Text Length by Language**: A boxplot depicting the variation in text lengths across languages.
3. **Confidence Scores**: A histogram illustrating the distribution of prediction confidence scores.

These visualizations tell a story about:
- The prevalence of languages in the dataset.
- Variations in sentence length across languages.
- The reliability of predictions based on confidence scores.

---

## Setup and Installation

### **Prerequisites**
1. Flutter installed on your system.
2. Python 3.8 or later installed.
3. FastAPI environment setup.

### **Steps**
1. Clone the repository:
   ```bash
   git clone <repo-url>
   cd LingoPredict
   
2. Install Flutter dependencies:
flutter pub get

3. Install Python dependencies:
pip install -r requirements.txt
Run the backend server:
uvicorn main:app --reload

4. Launch the Flutter app:
flutter run

API Documentation

Prediction Endpoint

URL: /predict

Method: POST

Input: {"sentences": ["text"]}

Output: Predicted language and confidence score.

Retrain Endpoint

URL: /retrain

Method: POST

Input: .csv file.

Output: Model metrics and a download URL.

Model Download Endpoint

URL: /download-retrained-model

Method: GET

Output: Downloads the retrained model file.

Future Enhancements

Integrate advanced visualizations using Flutter.

Support for multiple datasets.

Real-time language translation features.

Web-based version of the app.

License
This project is licensed under Mariam Temilola Azeez

For inquiries, contact - mariamazeez1209@gmail.com.
