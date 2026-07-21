from flask import Flask, jsonify, send_from_directory
import os

BASE_DIR = os.path.dirname(__file__)
app = Flask(__name__, static_folder=os.path.join(BASE_DIR, "mini_app", "static"), static_url_path="/static")

@app.route("/")
def index():
    return send_from_directory(os.path.join(BASE_DIR, "mini_app"), "index.html")

@app.route("/health")
def health_check():
    return "Nasrium Ecosystem is LIVE."

@app.route("/webhook", methods=["POST"])
def webhook():
    return jsonify(status="ok")

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)
