from locust import HttpUser, task, between

class LanguageDetectionUser(HttpUser):
    # Set the wait time between tasks
    wait_time = between(1, 3)

    # Define the task to be performed
    @task
    def test_prediction_endpoint(self):
        # Example sentence for prediction (you can replace it with dynamic sentences)
        data = {"sentences": ["This is a test sentence."]}

        # Make a POST request to the prediction endpoint
        self.client.post("/predict", json=data)

    @task
    def test_retrain_endpoint(self):
        # Example dataset for retraining
        file = {
            "file": open("data/TestLanguageDetectionDataSet.csv", "rb")
        }
        self.client.post("/retrain", files=file)

