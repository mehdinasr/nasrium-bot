import os

file_path = 'mini_api.py'

if not os.path.exists(file_path):
    print("[FATAL] mini_api.py not found!")
    exit(1)

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

if "from Core.App.WalletEngine import WalletEngine" not in content:
    content = "from Core.App.WalletEngine import WalletEngine\n" + content
    print("[OK] WalletEngine imported.")

wallet_endpoints = '''
@app.route("/api/wallet/buy", methods=["POST"])
def buy_nsm_hard():
    try:
        data = request.json
        uid = data.get("user_id")
        ton_amount = data.get("ton_amount", 0)
        if not uid: return jsonify({"error": "User ID required"}), 400

        p = players_collection.find_one({"user_id": uid})
        if not p: return jsonify({"error": "Player not found"}), 404

        result = WalletEngine.attempt_ton_purchase(ton_amount, p)

        if result["success"]:
            players_collection.update_one(
                {"user_id": uid},
                {"$set": {"nsm_hard": result["new_nsm_hard_balance"]}}
            )
            return jsonify(result)
        else:
            return jsonify(result), 400

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/api/wallet/withdraw", methods=["POST"])
def withdraw_nsm_hard():
    try:
        data = request.json
        uid = data.get("user_id")
        amount = data.get("amount", 0)
        if not uid: return jsonify({"error": "User ID required"}), 400

        p = players_collection.find_one({"user_id": uid})
        if not p: return jsonify({"error": "Player not found"}), 404

        result = WalletEngine.attempt_withdrawal(amount, p)

        if result["success"]:
            players_collection.update_one(
                {"user_id": uid},
                {"$set": {"nsm_hard": result["new_nsm_hard_balance"]}}
            )
            return jsonify(result)
        else:
            return jsonify(result), 400

    except Exception as e:
        return jsonify({"error": str(e)}), 500
'''

if "/api/wallet/buy" not in content:
    if "app.run(host=" in content:
        content = content.replace("app.run(host=", wallet_endpoints + "\napp.run(host=", 1)
        print("[OK] Wallet API endpoints injected.")
    else:
        content += wallet_endpoints
        print("[OK] Wallet API endpoints appended.")
else:
    print("[INFO] Wallet API endpoints already exist.")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
