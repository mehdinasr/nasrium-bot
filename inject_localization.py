with open("mini_api.py", "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace(chr(0xFEFF), "")

localization_route = """
# ---- Localization ----
LOCALIZATION_DIR = os.path.join(BASE_DIR, "Localization")
SUPPORTED_LANG_CODES = {"ar","az","de","el","en","es","fa","fr","hi","id","it","ja","ko","nl","pl","pt","ro","ru","th","tr","uk","ur","vi","zh-CN","zh-TW"}

@app.route("/api/localization/<lang_code>", methods=["GET"])
def get_localization(lang_code):
    safe_code = lang_code if lang_code in SUPPORTED_LANG_CODES else "en"
    file_path = os.path.join(LOCALIZATION_DIR, f"{safe_code}.json")
    if not os.path.isfile(file_path):
        file_path = os.path.join(LOCALIZATION_DIR, "en.json")
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f)
        return jsonify(data)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

"""

if "get_localization" not in content:
    content = content.replace("if __name__ == \"__main__\":", localization_route + "if __name__ == \"__main__\":", 1)
    print("[OK] Localization route added.")
else:
    print("[INFO] Already exists.")

if "import json" not in content:
    content = content.replace("import os\n", "import os\nimport json\n", 1)
    print("[OK] json import added.")

with open("mini_api.py", "w", encoding="utf-8") as f:
    f.write(content)
