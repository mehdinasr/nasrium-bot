with open("mini_api.py", "r", encoding="utf-8") as f:
    content = f.read()

old = "with open(file_path, \"r\", encoding=\"utf-8\") as f:\n            data = json.load(f)"
new = "with open(file_path, \"r\", encoding=\"utf-8-sig\") as f:\n            data = json.load(f)"

if old in content:
    content = content.replace(old, new)
    print("[OK] Fixed to utf-8-sig encoding.")
else:
    print("[WARN] Pattern not found, may need manual check.")

with open("mini_api.py", "w", encoding="utf-8") as f:
    f.write(content)
