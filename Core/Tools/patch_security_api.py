import os

file_path = 'mini_api.py'

if not os.path.exists(file_path):
    print("[FATAL] mini_api.py not found!")
    exit(1)

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

if "from Core.App.SentinelEngine import SentinelEngine" not in content:
    content = "from Core.App.SentinelEngine import SentinelEngine\n" + content
    print("[OK] SentinelEngine imported.")

# آپدیت روت چت برای دریافت زبان کاربر
if 'def ask_nexus():' in content:
    content = content.replace('query = data.get("query", "")', 'query = data.get("query", "")\n        lang = data.get("lang", "en")')
    content = content.replace('naxus = NAXUSAssistant(uid, p)', 'naxus = NAXUSAssistant(uid, p, lang)')
    print("[OK] NAXUS Chat API updated with lang param.")

# تزریق روت امنیتی برای بن کردن
security_endpoint = '''
@app.route("/api/security/ban", methods=["POST"])
def ban_user():
    try:
        data = request.json
        uid = data.get("user_id")
        reason = data.get("reason", "Violation")
        if not uid: return jsonify({"error": "User ID required"}), 400
        result = SentinelEngine.apply_ban(uid, players_collection, reason)
        return jsonify(result)
    except Exception as e:
        return jsonify({"error": str(e)}), 500
'''

if "/api/security/ban" not in content:
    if "app.run(host=" in content:
        content = content.replace("app.run(host=", security_endpoint + "\napp.run(host=", 1)
        print("[OK] Security API endpoint injected.")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
