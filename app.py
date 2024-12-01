from fastapi import FastAPI, HTTPException, UploadFile, File
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
from src.model import build_simple_model, train_model, save_model
from src.prediction import predict

# Initialize FastAPI
app = FastAPI(title="Language Detection API")

# Load pre-trained artifacts
model_path = "models/language_detection_model_.keras"
vectorizer_path = "models/vectorizer.pkl"
label_encoder_path = "models/label_encoder.pkl"

# Load the model
model = load_model(model_path)

# Load vectorizer and label encoder
with open(vectorizer_path, 'rb') as vec_file:
    vectorizer = pickle.load(vec_file)

with open(label_encoder_path, 'rb') as le_file:
    label_encoder = pickle.load(le_file)

# Input data model
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
        
        # Save the retrained model and preprocessors
        save_model(new_model, model_path)
        with open(vectorizer_path, 'wb') as vec_file:
            pickle.dump(vectorizer, vec_file)
        with open(label_encoder_path, 'wb') as le_file:
            pickle.dump(label_encoder, le_file)
        
        return {
            "detail": "Model retrained successfully!",
            "download_instruction": "You can download the retrained model by visiting the '/download-retrained-model' endpoint."
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        os.remove(temp_file_path)

@app.get("/download-retrained-model")
async def download_retrained_model():
    return FileResponse(model_path, filename="retrained_model.keras")

@app.get("/")
def read_root():
    return {"message": "Welcome to Lola's Language Prediction API!"}