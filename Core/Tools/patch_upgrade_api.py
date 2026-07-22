import os

file_path = 'mini_api.py'

if not os.path.exists(file_path):
    print("[FATAL] mini_api.py not found!")
    exit(1)

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# اضافه کردن import
if "from Core.App.GameEngine import GameEngine" not in content:
    content = "from Core.App.GameEngine import GameEngine\n" + content
    print("[OK] GameEngine imported.")

# اضافه کردن API Endpoint جدید برای ارتقا
upgrade_endpoint = '''
@app.route("/api/upgrade/nexus", methods=["POST"])
def upgrade_nexus():
    try:
        data = request.json
        uid = data.get("user_id")
        if not uid:
            return jsonify({"error": "User ID required"}), 400

        p = players_collection.find_one({"user_id": uid})
        if not p:
            return jsonify({"error": "Player not found"}), 404

        result = GameEngine.attempt_nexus_upgrade(p)

        if result["success"]:
            # آپدیت دیتابیس با منابع و سطح جدید
            players_collection.update_one(
                {"user_id": uid},
                {"$set": {
                    "gold": result["new_gold"],
                    "nsm_soft": result["new_nsm_soft"],
                    "town_hall_level": result["new_level"]
                }}
            )
            return jsonify(result)
        else:
            return jsonify(result), 400

    except Exception as e:
        return jsonify({"error": str(e)}), 500
'''

if "/api/upgrade/nexus" not in content:
    # تزریق به انتهای فایل قبل از اجرای app.run
    if "app.run(host=" in content:
        content = content.replace("app.run(host=", upgrade_endpoint + "\napp.run(host=", 1)
        print("[OK] Upgrade API endpoint injected.")
    else:
        content += upgrade_endpoint
        print("[OK] Upgrade API endpoint appended.")
else:
    print("[INFO] Upgrade API endpoint already exists.")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
