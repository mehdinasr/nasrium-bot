with open("mini_api.py", "r", encoding="utf-8") as f:
    content = f.read()

if "from Core.App.SimpleBuildingEngine import SimpleBuildingEngine" not in content:
    content = "from Core.App.SimpleBuildingEngine import SimpleBuildingEngine\n" + content
    print("[OK] SimpleBuildingEngine imported.")

new_route = """
@app.route("/api/upgrade/building", methods=["POST"])
def upgrade_building():
    try:
        data = request.json
        uid = data.get("user_id")
        b_type = data.get("building_type")
        if not uid or not b_type:
            return jsonify({"error": "Missing data"}), 400
        p = players_collection.find_one({"user_id": uid})
        if not p:
            return jsonify({"error": "Player not found"}), 404
        result = SimpleBuildingEngine.attempt_upgrade(b_type, p)
        if result["success"]:
            update_fields = {
                "gold": result["new_gold"],
                f"buildings.{b_type}": result["new_level"]
            }
            players_collection.update_one(
                {"user_id": uid},
                {"$set": update_fields}
            )
            return jsonify(result)
        else:
            return jsonify(result), 400
    except Exception as e:
        return jsonify({"error": str(e)}), 500

"""

content = content.replace('if __name__ == "__main__":', new_route + 'if __name__ == "__main__":', 1)
print("[OK] Building upgrade endpoint injected.")

with open("mini_api.py", "w", encoding="utf-8") as f:
    f.write(content)
