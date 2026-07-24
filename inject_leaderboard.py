with open("mini_api.py", "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace(chr(0xFEFF), "")

if "from Core.App.LeaderboardEngine import LeaderboardEngine" not in content:
    content = "from Core.App.LeaderboardEngine import LeaderboardEngine\n" + content
    print("[OK] LeaderboardEngine imported.")

new_route = """
@app.route("/api/leaderboard/top", methods=["GET"])
def leaderboard_top():
    try:
        top_players = LeaderboardEngine.get_top_players(players_collection, limit=10)
        return jsonify({"success": True, "leaderboard": top_players})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

"""

if "/api/leaderboard/top" not in content:
    content = content.replace("if __name__ == \"__main__\":", new_route + "if __name__ == \"__main__\":", 1)
    print("[OK] Leaderboard route injected.")
else:
    print("[INFO] Route already exists.")

with open("mini_api.py", "w", encoding="utf-8") as f:
    f.write(content)
