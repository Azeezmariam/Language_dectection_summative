### LingoPredict - Language Prediction and Model Retraining Tool
### Project Description

### LingoPredict is a tool designed to predict languages based on input sentences and allows users to retrain the model with new data. The application provides an easy-to-use Flutter interface with a Python-based backend powered by FastAPI. This project aims to provide real-time language predictions and a retraining option for custom datasets.

### Demo

### Check out the video demo of the LingoPredict app:

### YouTube Link to Demo - https://youtu.be/tY_-tLf3CTo

### API Documentation

### Prediction Endpoint
**URL**: /predict
**Method**: POST
**Input**:
JSON
{
  "sentences": ["text"]
}

**Output**: Predicted language and confidence score.

### Retrain Endpoint
**URL**: /retrain
**Method**: POST
**Input**: .csv file containing the training data.
**Output**: Model metrics and a download URL.

### Model Download Endpoint
**URL**: /download-retrained-model
**Method**: GET
**Output**: Downloads the retrained model file.

### Flood Request Simulation Results
**Test Summary**
**Requests**:
**POST /predict**: 5 requests made, 0 failures.
**POST /retrain**: 8 requests made, 2 failures.
**Total (Aggregated)**: 13 requests made, with 2 failures (failure rate of 15%).
### Latency:
### Median Response Time:
**/predict**: 13,000 ms
**/retrain**: 21,000 ms
### 95%ile Response Time:
**/predict**: 24,000 ms
**/retrain**: 33,000 ms
### 99%ile Response Time:
**/predict**: 33,000 ms
**/retrain**: 33,000 ms
### Average Response Time:
**/predict**: 11,882.1 ms
**/retrain**: 20,088.37 ms
### Failures:
**/retrain**: 2 failures (out of 8 requests).
### Failure Rate: 15% overall.
### Request Size:
**Average response size**: 166.62 bytes for both endpoints.
### Throughput:
**Requests per Second (RPS)**: No active requests during this test (Current RPS: 0).
**Failures per Second**: 0% failure rate at the moment.
### Performance Metrics:
**Max Latency**: The highest recorded latency was 33,532 ms for the /retrain endpoint.
### Setup Instructions
### Follow these steps to set up and run the project:

### Clone the repository
```Bash
git clone <repo-url>
cd LingoPredict

### Install Flutter dependencies
```Bash
flutter pub get

### Install Python dependencies
**Make sure you have pip installed, then install the required Python packages**:

```Bash
pip install -r requirements.txt

### Run the backend server
**Start the FastAPI backend server using uvicorn**:

```Bash
uvicorn main:app --reload
Use code with caution.

### Launch the Flutter app
**Run the Flutter app to interact with the backend**:

```Bash
flutter run

### Future Enhancements
Integrate advanced visualizations using Flutter.
Support for multiple datasets.
Real-time language translation features.
Web-based version of the app.

### License
This project is licensed under the MIT License. See LICENSE for details.

### Contact
For inquiries, contact Mariam Temilola Azeez at mariamazeez1209@gmail.com.






