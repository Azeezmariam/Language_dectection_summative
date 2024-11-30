from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from tensorflow.keras.models import load_model
import numpy as np
import pickle
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.preprocessing import LabelEncoder

# Initialize FastAPI app
app = FastAPI()

# Load the model and vectorizer
with open('models/language_detection_model.pkl', 'rb') as f:
    model = pickle.load(f)
vectorizer = pickle.load(open('models/tfidf_vectorizer.pkl', 'rb'))  # Your vectorizer file
label_encoder = pickle.load(open('models/label_encoder.pkl', 'rb'))  # Your label encoder file

# Pydantic model for the input data
class TextInput(BaseModel):
    text: str

# Prediction function
def predict_language(text: str) -> str:
    # Preprocess the input text (same preprocessing steps as before)
    text_vectorized = vectorizer.transform([text]).toarray()
    
    # Get model prediction
    prediction = model.predict(text_vectorized)
    
    # Convert prediction to class label
    predicted_class = np.argmax(prediction, axis=1)[0]
    
    # Map class label to language
    predicted_language = label_encoder.inverse_transform([predicted_class])[0]
    return predicted_language

# Prediction endpoint
@app.post("/predict/")
async def predict_endpoint(input_data: TextInput):
    try:
        # Get prediction from the model
        predicted_language = predict_language(input_data.text)
        return {"predicted_language": predicted_language}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    


@app.get("/")
def read_root():
    return{"message": "Welcome to Lola's Language Translation API!"}