import os

file_path = 'mini_api.py'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

if 'from Core.App.BuildingEngine import BuildingEngine' not in content:
    content = 'from Core.App.BuildingEngine import BuildingEngine\n' + content
    print('[OK] BuildingEngine imported.')

nexus_endpoint = '''
@app.route("/api/upgrade/nexus", methods=["POST"])
def upgrade_nexus():
    try:
        data = request.json
        uid = data.get("user_id")
        if not uid: return jsonify({"error": "User ID required"}), 400
        p = players_collection.find_one({"user_id": uid})
        if not p: return jsonify({"error": "Player not found"}), 404
        if p.get("is_building", False):
            return jsonify({"success": False, "message": "Already under construction."}), 400
        success, updated = BuildingEngine.start_upgrade(p)
        if success:
            players_collection.update_one(
                {"user_id": uid},
                {"\": {
                    "gold": updated["gold"],
                    "construction_until": updated["construction_until"],
                    "is_building": updated["is_building"]
                }}
            )
            return jsonify({"success": True, "message": "Nexus upgrade started!", "construction_until": updated["construction_until"]})
        else:
            return jsonify({"success": False, "message": "Insufficient Gold."}), 400
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/api/upgrade/nexus/finalize", methods=["POST"])
def finalize_nexus_upgrade():
    try:
        data = request.json
        uid = data.get("user_id")
        if not uid: return jsonify({"error": "User ID required"}), 400
        p = players_collection.find_one({"user_id": uid})
        if not p: return jsonify({"error": "Player not found"}), 404
        success, updated = BuildingEngine.finalize_upgrade(p)
        if success:
            players_collection.update_one(
                {"user_id": uid},
                {"\": {
                    "town_hall_level": updated["town_hall_level"],
                    "is_building": updated["is_building"],
                    "construction_until": updated["construction_until"]
                }}
            )
            return jsonify({"success": True, "message": "Nexus upgraded!", "new_level": updated["town_hall_level"]})
        else:
            return jsonify({"success": False, "message": "Construction not finished yet."})
    except Exception as e:
        return jsonify({"error": str(e)}), 500
'''

if '/api/upgrade/nexus' not in content:
    if 'app.run(host=' in content:
        content = content.replace('app.run(host=', nexus_endpoint + '\napp.run(host=', 1)
        print('[OK] Nexus upgrade endpoints injected.')
else:
    print('[INFO] Already exists.')

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
