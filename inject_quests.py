with open("mini_api.py", "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace(chr(0xFEFF), "")

if "from Core.App.QuestEngine import QuestEngine" not in content:
    content = "from Core.App.QuestEngine import QuestEngine\n" + content
    print("[OK] QuestEngine imported.")

old_snippet = "WarEngine.record_attack_score(attacker_syn, defender_syn, wars_collection)\n        return jsonify(result)"
new_snippet = ("WarEngine.record_attack_score(attacker_syn, defender_syn, wars_collection)\n"
               "                players_collection.update_one(\n"
               "                    {\"user_id\": attacker_uid},\n"
               "                    {\"$inc\": {\"raid_wins\": 1}}\n"
               "                )\n"
               "        return jsonify(result)")

if old_snippet in content:
    content = content.replace(old_snippet, new_snippet, 1)
    print("[OK] raid_wins increment added.")
else:
    print("[WARN] Could not find the exact raid snippet to patch - skipped, check manually.")

quest_routes = """
@app.route("/api/quests/status", methods=["POST"])
def quest_status():
    try:
        data = request.json
        uid = data.get("user_id")
        if not uid:
            return jsonify({"error": "User ID required"}), 400
        p = players_collection.find_one({"user_id": uid})
        if not p:
            return jsonify({"error": "Player not found"}), 404
        quests = QuestEngine.get_quest_status(p)
        return jsonify({"success": True, "quests": quests})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/api/quests/claim", methods=["POST"])
def quest_claim():
    try:
        data = request.json
        uid = data.get("user_id")
        quest_id = data.get("quest_id")
        if not uid or not quest_id:
            return jsonify({"error": "Missing data"}), 400
        p = players_collection.find_one({"user_id": uid})
        if not p:
            return jsonify({"error": "Player not found"}), 404
        success, message = QuestEngine.claim_quest(p, quest_id)
        if success:
            players_collection.update_one(
                {"user_id": uid},
                {"$set": {
                    "completed_airdrop_quests": p["completed_airdrop_quests"],
                    "airdrop_bonus_points": p["airdrop_bonus_points"]
                }}
            )
            return jsonify({"success": True, "message": message})
        else:
            return jsonify({"success": False, "message": message}), 400
    except Exception as e:
        return jsonify({"error": str(e)}), 500

"""

if "/api/quests/status" not in content:
    content = content.replace('if __name__ == "__main__":', quest_routes + 'if __name__ == "__main__":', 1)
    print("[OK] Quest routes injected.")
else:
    print("[INFO] Quest routes already exist.")

with open("mini_api.py", "w", encoding="utf-8") as f:
    f.write(content)
