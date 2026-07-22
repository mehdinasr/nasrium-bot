import os

file_path = 'mini_api.py'

if not os.path.exists(file_path):
    print("[FATAL] mini_api.py not found!")
    exit(1)

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# اضافه کردن روت مانیفست
manifest_route = '''
@app.route("/tonconnect-manifest.json", methods=["GET"])
def get_manifest():
    return send_from_directory('mini_app', 'tonconnect-manifest.json')
'''

if "/tonconnect-manifest.json" not in content:
    if "app.run(host=" in content:
        content = content.replace("app.run(host=", manifest_route + "\napp.run(host=", 1)
        print("[OK] Manifest route injected.")

# اضافه کردن روت اتصال کیف پول
link_wallet_endpoint = '''
@app.route("/api/wallet/link", methods=["POST"])
def link_wallet():
    try:
        data = request.json
        uid = data.get("user_id")
        wallet_address = data.get("wallet_address")
        if not uid or not wallet_address:
            return jsonify({"error": "Missing data"}), 400

        p = players_collection.find_one({"user_id": uid})
        if not p:
            return jsonify({"error": "Player not found"}), 404

        # ذخیره آدرس کیف پول در دیتابیس
        players_collection.update_one(
            {"user_id": uid},
            {"$set": {"ton_wallet_address": wallet_address}}
        )
        return jsonify({"success": True, "message": "Wallet linked successfully"})

    except Exception as e:
        return jsonify({"error": str(e)}), 500
'''

if "/api/wallet/link" not in content:
    if "app.run(host=" in content:
        content = content.replace("app.run(host=", link_wallet_endpoint + "\napp.run(host=", 1)
        print("[OK] Wallet Link API injected.")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
