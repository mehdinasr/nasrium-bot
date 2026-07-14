import os

file_path = 'mini_api.py'

if not os.path.exists(file_path):
    print("[FATAL] mini_api.py not found!")
    exit(1)

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

if "from Core.App.SubscriptionEngine import SubscriptionEngine" not in content:
    content = "from Core.App.SubscriptionEngine import SubscriptionEngine\n" + content
    print("[OK] SubscriptionEngine imported.")

# روت فعالسازی اشتراک
sub_endpoint = '''
@app.route("/api/subscribe/activate", methods=["POST"])
def activate_sub():
    try:
        data = request.json
        uid = data.get("user_id")
        tier_name = data.get("tier")
        if not uid or not tier_name: return jsonify({"error": "Missing data"}), 400

        p = players_collection.find_one({"user_id": uid})
        if not p: return jsonify({"error": "Player not found"}), 404

        result = SubscriptionEngine.activate_subscription(uid, tier_name, p, players_collection)
        if result["success"]: return jsonify(result)
        else: return jsonify(result), 400

    except Exception as e:
        return jsonify({"error": str(e)}), 500
'''

if "/api/subscribe/activate" not in content:
    if "app.run(host=" in content:
        content = content.replace("app.run(host=", sub_endpoint + "\napp.run(host=", 1)
        print("[OK] Subscription API endpoint injected.")

# آپدیت روت ثبت نام برای پشتیبانی از Deep Link رفرال
if 'def register_user():' in content:
    old_register_logic = 'upline_id = data.get("upline_id")\n        if not uid: return jsonify({"error": "User ID required"}), 400'
    new_register_logic = 'upline_id = data.get("upline_id")\n        ref_code = data.get("ref_code")\n        if ref_code and ref_code.startswith("REF_"):\n            try: upline_id = int(ref_code.split("_")[1])\n            except: pass\n        if not uid: return jsonify({"error": "User ID required"}), 400'
    content = content.replace(old_register_logic, new_register_logic)
    print("[OK] Referral Deep Link logic injected into Register API.")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
