import pandas as pd
import string
from sklearn.utils import resample
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.model_selection import train_test_split
from keras.utils import to_categorical
from sklearn.preprocessing import LabelEncoder
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score

def load_and_clean_data(file_path):
    df = pd.read_csv(file_path)
    
    # Step 1: Lowercasing and removing punctuation
    df['Text'] = df['Text'].str.lower().apply(
        lambda x: x.translate(str.maketrans('', '', string.punctuation))
    )
    
    return df

def balance_classes(df, target_column):
    class_distribution = df[target_column].value_counts()
    
    # Separate majority and minority classes
    majority_class = df[df[target_column] == class_distribution.idxmax()]
    minority_classes = [
        resample(
            df[df[target_column] == lang],
            replace=True,
            n_samples=len(majority_class),
            random_state=42
        ) for lang in class_distribution.index if lang != class_distribution.idxmax()
    ]
    
    # Combine all classes and shuffle
    balanced_df = pd.concat([majority_class] + minority_classes).sample(frac=1, random_state=42)
    return balanced_df

def preprocess_data(df, target_column):
    vectorizer = TfidfVectorizer(max_features=5000)
    X = vectorizer.fit_transform(df['Text'])
    y = df[target_column]
    return X, y, vectorizer

def split_data(X, y):
    X_train, X_temp, y_train, y_temp = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)
    X_val, X_test, y_val, y_test = train_test_split(X_temp, y_temp, test_size=0.5, random_state=42, stratify=y_temp)
    return X_train, X_val, X_test, y_train, y_val, y_test

def encode_labels(y_train, y_val, y_test):
    label_encoder = LabelEncoder()
    y_train_enc = to_categorical(label_encoder.fit_transform(y_train))
    y_val_enc = to_categorical(label_encoder.transform(y_val))
    y_test_enc = to_categorical(label_encoder.transform(y_test))
    return y_train_enc, y_val_enc, y_test_enc, label_encoder
