import os

file_path = 'mini_api.py'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

if 'from Core.App.TroopEngine import TroopEngine' not in content:
    content = 'from Core.App.TroopEngine import TroopEngine\n' + content
    print('[OK] TroopEngine imported.')

train_endpoint = '''
@app.route("/api/troops/train", methods=["POST"])
def train_troops():
    try:
        data = request.json
        uid = data.get("user_id")
        unit_type = data.get("unit_type", "warrior")
        count = data.get("count", 1)
        if not uid:
            return jsonify({"error": "Missing ID"}), 400
        if unit_type not in TroopEngine.UNIT_TYPES:
            return jsonify({"error": "Invalid unit type"}), 400
        p = players_collection.find_one({"user_id": uid})
        if not p:
            return jsonify({"error": "Player not found"}), 404
        can_afford, total_cost = TroopEngine.can_train(p, unit_type, count)
        if not can_afford:
            return jsonify({"success": False, "message": f"Insufficient Gold. {total_cost} required."}), 400
        players_collection.update_one(
            {"user_id": uid},
            {"$inc": {"gold": -total_cost, "troops": count}}
        )
        return jsonify({
            "success": True,
            "unit_type": unit_type,
            "count": count,
            "cost": total_cost,
            "message": f"{count} {TroopEngine.UNIT_TYPES[unit_type][\"label\"]} trained!"
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500
'''

if '/api/troops/train' not in content:
    if 'app.run(host=' in content:
        content = content.replace('app.run(host=', train_endpoint + '\napp.run(host=', 1)
        print('[OK] Train endpoint injected.')
else:
    print('[INFO] Already exists.')

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
