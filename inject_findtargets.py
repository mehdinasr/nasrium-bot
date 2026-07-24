with open("mini_api.py", "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace(chr(0xFEFF), "")

if "from Core.App.TargetFinderEngine import TargetFinderEngine" not in content:
    content = "from Core.App.TargetFinderEngine import TargetFinderEngine\n" + content
    print("[OK] TargetFinderEngine imported.")

new_route = """
@app.route("/api/raid/find_targets", methods=["POST"])
def find_targets():
    try:
        data = request.json
        uid = data.get("user_id")
        if not uid:
            return jsonify({"error": "User ID required"}), 400
        p = players_collection.find_one({"user_id": uid})
        if not p:
            return jsonify({"error": "Player not found"}), 404
        targets = TargetFinderEngine.find_targets(uid, p, players_collection, limit=5)
        return jsonify({"success": True, "targets": targets})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

"""

if "/api/raid/find_targets" not in content:
    content = content.replace('if __name__ == "__main__":', new_route + 'if __name__ == "__main__":', 1)
    print("[OK] find_targets route injected.")
else:
    print("[INFO] Route already exists.")

with open("mini_api.py", "w", encoding="utf-8") as f:
    f.write(content)
