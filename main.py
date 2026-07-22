from flask import Flask, jsonify
import time

app = Flask(__name__)

@app.route('/')
def health_check():
    return jsonify({"status": "Nasrium Core Online", "timestamp": time.time()})

if __name__ == '__main__':
    print("NAXUS Core Initializing on Port 8080...")
    app.run(host='0.0.0.0', port=8080)
