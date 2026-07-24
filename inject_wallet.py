with open("mini_api.py", "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace(chr(0xFEFF), "")

if "from Core.App.WalletEngine import WalletEngine" not in content:
    content = "from Core.App.WalletEngine import WalletEngine\n" + content
    print("[OK] WalletEngine imported.")

wallet_routes = """
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
        success, message = WalletEngine.link_wallet(p, wallet_address)
        if success:
            players_collection.update_one(
                {"user_id": uid},
                {"$set": {"ton_wallet": p["ton_wallet"], "is_verified_holder": p["is_verified_holder"]}}
            )
            return jsonify({"success": True, "message": message})
        else:
            return jsonify({"success": False, "message": message}), 400
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/api/wallet/check_deposit", methods=["POST"])
def check_deposit():
    try:
        data = request.json
        uid = data.get("user_id")
        if not uid:
            return jsonify({"error": "User ID required"}), 400
        p = players_collection.find_one({"user_id": uid})
        if not p:
            return jsonify({"error": "Player not found"}), 404
        deposit_address = os.environ.get("WALLET_ADDRESS")
        result = WalletEngine.check_and_process_deposits(uid, p, db["processed_transactions"], deposit_address)
        if result["success"] and result["credited_nsm_hard"] > 0:
            players_collection.update_one(
                {"user_id": uid},
                {"$set": {"nsm_hard": result["new_nsm_hard"]}}
            )
        return jsonify(result)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/api/wallet/withdraw", methods=["POST"])
def withdraw_ton():
    try:
        data = request.json
        uid = data.get("user_id")
        amount = data.get("amount", 0)
        if not uid:
            return jsonify({"error": "User ID required"}), 400
        p = players_collection.find_one({"user_id": uid})
        if not p:
            return jsonify({"error": "Player not found"}), 404
        result = WalletEngine.attempt_withdrawal(p, amount)
        if result["success"]:
            players_collection.update_one(
                {"user_id": uid},
                {"$set": {"nsm_hard": result["new_nsm_hard"]}}
            )
            return jsonify(result)
        else:
            return jsonify(result), 400
    except Exception as e:
        return jsonify({"error": str(e)}), 500

"""

if "/api/wallet/link" not in content:
    content = content.replace('if __name__ == "__main__":', wallet_routes + 'if __name__ == "__main__":', 1)
    print("[OK] Wallet routes injected.")
else:
    print("[INFO] Wallet routes already exist.")

with open("mini_api.py", "w", encoding="utf-8") as f:
    f.write(content)
