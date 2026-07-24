import re

with open('mini_api.py', 'r', encoding='utf-8') as f:
    content = f.read()

# حذف ایمپورت قدیمی BuildingEngine
content = content.replace('from Core.App.BuildingEngine import BuildingEngine\n', '')

# پیدا کردن و حذف کل بلوک دو مسیر قدیمی (از شروع تابع اول تا قبل از app.run)
start_marker = '@app.route("/api/upgrade/nexus", methods=["POST"])'
end_marker = 'app.run(host='
start_idx = content.find(start_marker)
end_idx = content.find(end_marker)
if start_idx != -1 and end_idx != -1:
    content = content[:start_idx] + content[end_idx:]
    print('[OK] Old nexus routes removed.')
else:
    print('[WARN] Could not locate old routes cleanly.')

# اضافه کردن ایمپورت GameEngine
if 'from Core.App.GameEngine import GameEngine' not in content:
    content = 'from Core.App.GameEngine import GameEngine\n' + content
    print('[OK] GameEngine imported.')

new_nexus_endpoint = '''
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
            players_collection.update_one(
                {"user_id": uid},
                {"$set": {
                    "gold": result["new_gold"],
                    "nsm_soft": result["new_nsm_soft"],
                    "town_hall_level": result["new_level"],
                    "is_nexus_maxed": result["is_nexus_maxed"]
                }}
            )
            return jsonify(result)
        else:
            return jsonify(result), 400
    except Exception as e:
        return jsonify({"error": str(e)}), 500

'''

content = content.replace('app.run(host=', new_nexus_endpoint + 'app.run(host=', 1)
print('[OK] New GameEngine-based nexus endpoint injected.')

with open('mini_api.py', 'w', encoding='utf-8') as f:
    f.write(content)
