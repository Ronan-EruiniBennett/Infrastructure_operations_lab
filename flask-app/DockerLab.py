from flask import Flask

app = Flask(__name__)

# Home route
@app.route('/', methods=['GET'])
def home():
    return {"Project": "infrastructure operations lab"}, 200

# Health check endpoint
@app.route('/health', methods=['GET'])
def health():
    return {"status": "healthy"}, 200

# Version endpoint
@app.route('/version', methods=['GET'])
def version():
    return {"version": "1.0.0"}, 200

# Metric endpoint
@app.route('/metric', methods=['GET'])
def metric():
    return {"metric": counter()}, 200

def counter():
    # This is a placeholder for a counter function
    # In a real application, this could be connected to a database or in-memory store
    return {"requests": 42}
