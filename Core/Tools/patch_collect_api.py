import os

file_path = 'mini_api.py'

if not os.path.exists(file_path):
    print("[FATAL] mini_api.py not found!")
    exit(1)

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

if "from Core.App.ResourceEngine import ResourceEngine" not in content:
    content = "from Core.App.ResourceEngine import ResourceEngine\n" + content
    print("[OK] ResourceEngine imported.")

collection_endpoint = '''
@app.route("/api/collect", methods=["POST"])
def collect_resources():
    try:
        data = request.json
        uid = data.get("user_id")
        if not uid:
            return jsonify({"error": "User ID required"}), 400

        p = players_collection.find_one({"user_id": uid})
        if not p:
            return jsonify({"error": "Player not found"}), 404

        result = ResourceEngine.calculate_collection(p)

        # آپدیت دیتابیس با منابع جدید و زمان فعلی
        players_collection.update_one(
            {"user_id": uid},
            {"$set": {
                "gold": result["new_gold"],
                "gems": result["new_gems"],
                "last_collect_time": result["new_collect_time"]
            }}
        )
        return jsonify(result)

    except Exception as e:
        return jsonify({"error": str(e)}), 500
'''

if "/api/collect" not in content:
    if "app.run(host=" in content:
        content = content.replace("app.run(host=", collection_endpoint + "\napp.run(host=", 1)
        print("[OK] Collection API endpoint injected.")
    else:
        content += collection_endpoint
        print("[OK] Collection API endpoint appended.")
else:
    print("[INFO] Collection API endpoint already exists.")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
