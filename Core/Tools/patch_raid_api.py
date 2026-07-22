import os

file_path = 'mini_api.py'

if not os.path.exists(file_path):
    print("[FATAL] mini_api.py not found!")
    exit(1)

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

if "from Core.App.RaidEngine import RaidEngine" not in content:
    content = "from Core.App.RaidEngine import RaidEngine\n" + content
    print("[OK] RaidEngine imported.")

raid_endpoints = '''
@app.route("/api/raid/attack", methods=["POST"])
def execute_raid():
    try:
        data = request.json
        attacker_uid = data.get("attacker_id")
        defender_uid = data.get("defender_id")
        if not attacker_uid or not defender_uid: return jsonify({"error": "Missing IDs"}), 400
        if attacker_uid == defender_uid: return jsonify({"error": "Cannot raid yourself"}), 400

        attacker = players_collection.find_one({"user_id": attacker_uid})
        defender = players_collection.find_one({"user_id": defender_uid})
        if not attacker or not defender: return jsonify({"error": "Player not found"}), 404

        result = RaidEngine.initiate_raid(attacker, defender)

        if result["success"]:
            update_attacker = {
                "$inc": {"gold": result.get("loot_gold", 0), "gems": result.get("loot_gems", 0), "troops": -result.get("troops_lost", 0)}
            }
            players_collection.update_one({"user_id": attacker_uid}, update_attacker)

            if result["result"] == "Victory":
                update_defender = {
                    "$inc": {"gold": -result.get("loot_gold", 0), "gems": -result.get("loot_gems", 0)},
                    "$set": {"shield_active_until": time.time() + (12 * 3600)}
                }
                players_collection.update_one({"user_id": defender_uid}, update_defender)

        return jsonify(result)

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/api/raid/shield", methods=["POST"])
def buy_shield():
    try:
        data = request.json
        uid = data.get("user_id")
        if not uid: return jsonify({"error": "Missing ID"}), 400

        p = players_collection.find_one({"user_id": uid})
        if not p: return jsonify({"error": "Player not found"}), 404

        result = RaidEngine.activate_shield(p)
        if result["success"]:
            players_collection.update_one(
                {"user_id": uid},
                {"$set": {"nsm_hard": result["new_nsm_hard"], "shield_active_until": result["shield_expiry"]}}
            )
            return jsonify(result)
        else:
            return jsonify(result), 400

    except Exception as e:
        return jsonify({"error": str(e)}), 500
'''

if "/api/raid/attack" not in content:
    if "app.run(host=" in content:
        content = content.replace("app.run(host=", raid_endpoints + "\napp.run(host=", 1)
        print("[OK] Raid & Shield API endpoints injected.")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
