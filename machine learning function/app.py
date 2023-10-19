from flask import Flask, request, jsonify
import numpy as np
import pickle
import os  # Import the 'os' module for file path handling

app = Flask(__name__)

# Define the path to the model file
model_file_path = 'model.pkl'

# Add error handling to open the file
try:
    model = pickle.load(open(model_file_path, 'rb'))
except FileNotFoundError:
    # Handle the case where the file is not found
    model = None
    print(f"Error: The file '{model_file_path}' was not found.")
except Exception as e:
    # Handle other exceptions that may occur during file opening
    model = None
    print(f"Error: An exception occurred while opening '{model_file_path}': {str(e)}")

@app.route('/')
def index():
    return "Hello world"

@app.route('/predict', methods=['POST'])
def predict():
    if model is None:
        # Handle the case where the model is not available
        return jsonify({'error': 'Model not available'})
    # Get input data from POST request
    productname = int(request.form.get('productname'))
    problem = int(request.form.get('problem'))

    # Create input array for prediction
    input_query = np.array([[productname, problem]])

    # Make prediction
    result = model.predict(input_query)[0]

    # Return prediction as JSON response
    return jsonify(str(result))

if __name__ == '__main__':

    app.run(host='0.0.0.0', port=5000, debug=True)