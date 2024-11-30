from keras.models import Sequential
from keras.layers import Dense, Dropout, BatchNormalization
from keras.optimizers import Adam
from keras.regularizers import l2
from keras.callbacks import LearningRateScheduler

def build_simple_model(input_dim, output_dim):
    model = Sequential([
        Dense(128, input_dim=input_dim, activation='relu'),
        Dense(output_dim, activation='softmax')
    ])
    model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])
    return model

def build_optimized_model(input_dim, output_dim):
    def lr_scheduler(epoch, lr):
        return lr * 0.9 if epoch >= 5 else lr

    model = Sequential([
        Dense(128, input_dim=input_dim, activation='relu', kernel_regularizer=l2(0.001)),
        BatchNormalization(),
        Dropout(0.5),
        Dense(output_dim, activation='softmax')
    ])
    model.compile(optimizer=Adam(learning_rate=0.001), loss='categorical_crossentropy', metrics=['accuracy'])
    return model, LearningRateScheduler(lr_scheduler)

def train_model(model, X_train, y_train, X_val, y_val, callbacks=None, epochs=10, batch_size=32):
    history = model.fit(
        X_train.toarray(), y_train,
        validation_data=(X_val.toarray(), y_val),
        epochs=epochs, batch_size=batch_size, callbacks=callbacks
    )
    return history

def save_model(model, path):
    model.save(path)
