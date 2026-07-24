with open("mini_api.py", "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace(chr(0xFEFF), "")

if "from Core.App.MissionsEngine import MissionsEngine" not in content:
    content = "from Core.App.MissionsEngine import MissionsEngine\n" + content
    print("[OK] MissionsEngine imported.")

old_raid = (
    "WarEngine.record_attack_score(attacker_syn, defender_syn, wars_collection)\n"
    "                players_collection.update_one(\n"
    "                    {\"user_id\": attacker_uid},\n"
    "                    {\"$inc\": {\"raid_wins\": 1}}\n"
    "                )\n"
    "        return jsonify(result)"
)
new_raid = (
    "WarEngine.record_attack_score(attacker_syn, defender_syn, wars_collection)\n"
    "                MissionsEngine.record_progress(attacker, \"raids\", 1)\n"
    "                players_collection.update_one(\n"
    "                    {\"user_id\": attacker_uid},\n"
    "                    {\n"
    "                        \"$inc\": {\"raid_wins\": 1},\n"
    "                        \"$set\": {\n"
    "                            \"daily_mission_date\": attacker.get(\"daily_mission_date\"),\n"
    "                            \"daily_counters\": attacker.get(\"daily_counters\")\n"
    "                        }\n"
    "                    }\n"
    "                )\n"
    "        return jsonify(result)"
)
if old_raid in content:
    content = content.replace(old_raid, new_raid, 1)
    print("[OK] raid mission progress patched.")
else:
    print("[WARN] raid snippet not found - skipped.")

old_collect = (
    "result = ResourceEngine.calculate_collection(p)\n"
    "        players_collection.update_one(\n"
    "            {\"user_id\": uid},\n"
    "            {\"$set\": {\n"
    "                \"gold\": result[\"new_gold\"],\n"
    "                \"gems\": result[\"new_gems\"],\n"
    "                \"last_collect_time\": result[\"new_collect_time\"]\n"
    "            }}\n"
    "        )\n"
    "        return jsonify(result)"
)
new_collect = (
    "result = ResourceEngine.calculate_collection(p)\n"
    "        MissionsEngine.record_progress(p, \"gold_mined\", result.get(\"earned_gold\", 0))\n"
    "        players_collection.update_one(\n"
    "            {\"user_id\": uid},\n"
    "            {\"$set\": {\n"
    "                \"gold\": result[\"new_gold\"],\n"
    "                \"gems\": result[\"new_gems\"],\n"
    "                \"last_collect_time\": result[\"new_collect_time\"],\n"
    "                \"daily_mission_date\": p.get(\"daily_mission_date\"),\n"
    "                \"daily_counters\": p.get(\"daily_counters\")\n"
    "            }}\n"
    "        )\n"
    "        return jsonify(result)"
)
if old_collect in content:
    content = content.replace(old_collect, new_collect, 1)
    print("[OK] collect mission progress patched.")
else:
    print("[WARN] collect snippet not found - skipped.")

old_link = (
    "success, message = WalletEngine.link_wallet(p, wallet_address)\n"
    "        if success:\n"
    "            players_collection.update_one(\n"
    "                {\"user_id\": uid},\n"
    "                {\"$set\": {\"ton_wallet\": p[\"ton_wallet\"], \"is_verified_holder\": p[\"is_verified_holder\"]}}\n"
    "            )\n"
    "            return jsonify({\"success\": True, \"message\": message})"
)
new_link = (
    "success, message = WalletEngine.link_wallet(p, wallet_address)\n"
    "        if success:\n"
    "            MissionsEngine.record_progress(p, \"sync_ops\", 1)\n"
    "            players_collection.update_one(\n"
    "                {\"user_id\": uid},\n"
    "                {\"$set\": {\n"
    "                    \"ton_wallet\": p[\"ton_wallet\"],\n"
    "                    \"is_verified_holder\": p[\"is_verified_holder\"],\n"
    "                    \"daily_mission_date\": p.get(\"daily_mission_date\"),\n"
    "                    \"daily_counters\": p.get(\"daily_counters\")\n"
    "                }}\n"
    "            )\n"
    "            return jsonify({\"success\": True, \"message\": message})"
)
if old_link in content:
    content = content.replace(old_link, new_link, 1)
    print("[OK] wallet/link mission progress patched.")
else:
    print("[WARN] wallet/link snippet not found - skipped.")

missions_routes = """
@app.route("/api/missions/status", methods=["POST"])
def missions_status():
    try:
        data = request.json
        uid = data.get("user_id")
        if not uid:
            return jsonify({"error": "User ID required"}), 400
        p = players_collection.find_one({"user_id": uid})
        if not p:
            return jsonify({"error": "Player not found"}), 404
        missions = MissionsEngine.get_daily_missions(p)
        players_collection.update_one(
            {"user_id": uid},
            {"$set": {
                "daily_mission_date": p.get("daily_mission_date"),
                "daily_counters": p.get("daily_counters"),
                "claimed_daily_missions": p.get("claimed_daily_missions", [])
            }}
        )
        return jsonify({"success": True, "missions": missions})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/api/missions/claim", methods=["POST"])
def missions_claim():
    try:
        data = request.json
        uid = data.get("user_id")
        mission_id = data.get("mission_id")
        if not uid or not mission_id:
            return jsonify({"error": "Missing data"}), 400
        p = players_collection.find_one({"user_id": uid})
        if not p:
            return jsonify({"error": "Player not found"}), 404
        success, message = MissionsEngine.claim_mission(p, mission_id)
        if success:
            players_collection.update_one(
                {"user_id": uid},
                {"$set": {
                    "gold": p["gold"],
                    "power_score": p.get("power_score", 0),
                    "claimed_daily_missions": p["claimed_daily_missions"],
                    "daily_mission_date": p.get("daily_mission_date"),
                    "daily_counters": p.get("daily_counters")
                }}
            )
            return jsonify({"success": True, "message": message})
        else:
            return jsonify({"success": False, "message": message}), 400
    except Exception as e:
        return jsonify({"error": str(e)}), 500

"""

if "/api/missions/status" not in content:
    content = content.replace("if __name__ == \"__main__\":", missions_routes + "if __name__ == \"__main__\":", 1)
    print("[OK] Missions routes injected.")
else:
    print("[INFO] Missions routes already exist.")

with open("mini_api.py", "w", encoding="utf-8") as f:
    f.write(content)
