import os

file_path = 'mini_api.py'

if not os.path.exists(file_path):
    print("[FATAL] mini_api.py not found!")
    exit(1)

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

if "from Core.App.NAXUSCore import NAXUSAssistant" not in content:
    content = "from Core.App.NAXUSCore import NAXUSAssistant\n" + content
    print("[OK] NAXUSCore imported.")

chat_endpoint = '''
@app.route("/api/nexus/ask", methods=["POST"])
def ask_nexus():
    try:
        data = request.json
        uid = data.get("user_id")
        query = data.get("query", "")
        if not uid: return jsonify({"error": "User ID required"}), 400

        p = players_collection.find_one({"user_id": uid})
        if not p: return jsonify({"error": "Player not found"}), 404

        naxus = NAXUSAssistant(uid, p)
        response_text = naxus.ask_guide(query)

        return jsonify({"response": response_text})

    except Exception as e:
        return jsonify({"error": str(e)}), 500
'''

if "/api/nexus/ask" not in content:
    if "app.run(host=" in content:
        content = content.replace("app.run(host=", chat_endpoint + "\napp.run(host=", 1)
        print("[OK] NAXUS Chat API endpoint injected.")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
