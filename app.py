from fastapi import FastAPI, HTTPException, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse
from pydantic import BaseModel
import os
import pandas as pd
import pickle
import numpy as np
from keras.models import load_model
from keras.utils import to_categorical
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score
from src.model import build_simple_model, train_model, save_model
from src.prediction import predict

# Initialize FastAPI
app = FastAPI(title="Language Detection API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins for now, adjust later
    allow_credentials=True,
    allow_methods=["*"],  # Allows all HTTP methods
    allow_headers=["*"],  # Allows all headers
)

# Load pre-trained artifacts
model_path = "models/language_detection_model.keras"
vectorizer_path = "models/vectorizer.pkl"
label_encoder_path = "models/label_encoder.pkl"

# Load the model and preprocessing artifacts
model = load_model(model_path)

with open(vectorizer_path, 'rb') as vec_file:
    vectorizer = pickle.load(vec_file)

with open(label_encoder_path, 'rb') as le_file:
    label_encoder = pickle.load(le_file)

# Input data model for prediction request
class PredictionRequest(BaseModel):
    sentences: list[str]

# Endpoint to make predictions
@app.post("/predict")
async def make_prediction(request: PredictionRequest):
    sentences = request.sentences

    if not sentences:
        raise HTTPException(status_code=400, detail="No sentences provided")

    try:
        predictions = predict(model, vectorizer, sentences, label_encoder)
        return {"predictions": [{"sentence": sent, "language": lang} for sent, lang in zip(sentences, predictions)]}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# Endpoint to retrain the model
@app.post("/retrain")
async def retrain_model(file: UploadFile = File(...)):
    # Check if the uploaded file is a CSV
    if not file.filename.endswith(".csv"):
        raise HTTPException(status_code=400, detail="Only CSV files are supported")

    # Save uploaded file temporarily
    temp_file_path = f"temp_{file.filename}"
    with open(temp_file_path, "wb") as f:
        f.write(file.file.read())

    try:
        # Load new data
        df = pd.read_csv(temp_file_path)
        if "Text" not in df.columns or "Language" not in df.columns:
            raise HTTPException(status_code=400, detail="The CSV must contain 'Text' and 'Language' columns")
        
        # Preprocessing
        df['Text'] = df['Text'].str.lower().str.replace(r"[^\w\s]", "", regex=True)
        vectorizer = TfidfVectorizer(max_features=5000)
        X = vectorizer.fit_transform(df['Text'])
        y = df['Language']
        
        # Encode labels
        label_encoder = LabelEncoder()
        y_encoded = to_categorical(label_encoder.fit_transform(y))
        
        # Split data
        X_train, X_val, y_train, y_val = train_test_split(X, y_encoded, test_size=0.2, random_state=42)
        
        # Retrain model
        input_dim = X_train.shape[1]
        output_dim = y_encoded.shape[1]
        new_model = build_simple_model(input_dim, output_dim)
        train_model(new_model, X_train, y_train, X_val, y_val, epochs=10)
        
        # Calculate evaluation metrics
        y_val_pred = new_model.predict(X_val)
        y_val_pred_classes = y_val_pred.argmax(axis=1)
        y_val_true_classes = y_val.argmax(axis=1)

        accuracy = accuracy_score(y_val_true_classes, y_val_pred_classes)
        precision = precision_score(y_val_true_classes, y_val_pred_classes, average="weighted")
        recall = recall_score(y_val_true_classes, y_val_pred_classes, average="weighted")
        f1 = f1_score(y_val_true_classes, y_val_pred_classes, average="weighted")

        # Log metrics
        print(f"Metrics - Accuracy: {accuracy}, Precision: {precision}, Recall: {recall}, F1-Score: {f1}")

        # Save the retrained model and preprocessing artifacts
        save_model(new_model, model_path)
        with open(vectorizer_path, 'wb') as vec_file:
            pickle.dump(vectorizer, vec_file)
        with open(label_encoder_path, 'wb') as le_file:
            pickle.dump(label_encoder, le_file)
        
        # Reload the model after retraining
        model = load_model(model_path)

        return {
            "detail": "Model retrained successfully!",
            "metrics": {
                "accuracy": accuracy,
                "precision": precision,
                "recall": recall,
                "f1_score": f1
            },
            "model_download_url": "/download-retrained-model"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        os.remove(temp_file_path)

# Endpoint to download retrained model
@app.get("/download-retrained-model")
async def download_retrained_model():
    return FileResponse(model_path, filename="retrained_model.keras")

@app.get("/")
def read_root():
    return {"message": "Welcome to Lola's Language Prediction API!"}
