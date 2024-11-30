import numpy as np

def predict(model, vectorizer, sentences, label_encoder):
    # Preprocess input
    input_vectors = vectorizer.transform(sentences).toarray()
    
    # Make predictions
    predictions = model.predict(input_vectors)
    predicted_classes = predictions.argmax(axis=1)
    predicted_labels = label_encoder.inverse_transform(predicted_classes)
    
    return predicted_labels
