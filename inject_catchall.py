with open("mini_api.py", "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace(chr(0xFEFF), "")

catch_all = """
@app.route("/api/<path:unimplemented_path>", methods=["GET", "POST"])
def api_catch_all(unimplemented_path):
    return jsonify({}), 200

"""

if "api_catch_all" not in content:
    content = content.replace("if __name__ == \"__main__\":", catch_all + "if __name__ == \"__main__\":", 1)
    print("[OK] Catch-all fallback route added.")
else:
    print("[INFO] Already exists.")

with open("mini_api.py", "w", encoding="utf-8") as f:
    f.write(content)
