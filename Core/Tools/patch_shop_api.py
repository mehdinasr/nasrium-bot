import os

file_path = 'mini_api.py'

if not os.path.exists(file_path):
    print("[FATAL] mini_api.py not found!")
    exit(1)

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

if "from Core.App.ShopEngine import ShopEngine" not in content:
    content = "from Core.App.ShopEngine import ShopEngine\n" + content
    print("[OK] ShopEngine imported.")

shop_endpoint = '''
@app.route("/api/shop/buy", methods=["POST"])
def shop_buy():
    try:
        data = request.json
        uid = data.get("user_id")
        item_id = data.get("item_id")
        if not uid or not item_id: return jsonify({"error": "Missing data"}), 400

        p = players_collection.find_one({"user_id": uid})
        if not p: return jsonify({"error": "Player not found"}), 404

        result = ShopEngine.attempt_purchase(uid, item_id, p)

        if result["success"]:
            players_collection.update_one({"user_id": uid}, result["update_query"])
            return jsonify(result)
        else:
            return jsonify(result), 400

    except Exception as e:
        return jsonify({"error": str(e)}), 500
'''

if "/api/shop/buy" not in content:
    if "app.run(host=" in content:
        content = content.replace("app.run(host=", shop_endpoint + "\napp.run(host=", 1)
        print("[OK] Shop API endpoint injected.")
    else:
        content += shop_endpoint
        print("[OK] Shop API endpoint appended.")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
