from flask import Flask, request, jsonify
import os
import requests

app = Flask(__name__)

TELEGRAM_TOKEN = os.environ.get('TELEGRAM_TOKEN')
TELEGRAM_API = f"https://api.telegram.org/bot{TELEGRAM_TOKEN}"

@app.route('/webhook', methods=['POST'])
def webhook():
    try:
        data = request.get_json()
        
        if 'message' in data:
            chat_id = data['message']['chat']['id']
            text = data['message'].get('text', '')
            
            if text == '/start':
                send_message(chat_id, "سلام! ربات نصریوم فعال است 🚀")
        
        return jsonify({"status": "ok"})
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({"status": "error"})

def send_message(chat_id, text):
    url = f"{TELEGRAM_API}/sendMessage"
    data = {"chat_id": chat_id, "text": text}
    requests.post(url, json=data)

@app.route('/', methods=['GET'])
def index():
    return jsonify({"status": "Nasrium Bot Online"})

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8080))
    app.run(host="0.0.0.0", port=port)
