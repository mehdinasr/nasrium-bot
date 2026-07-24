with open("mini_app/static/js/app_logic_part1.js", "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace(chr(0xFEFF), "")

old = "const oldFetchComms = fetchComms;\nfetchComms = async () => {"
new = "async function fetchComms() {"

if old in content:
    content = content.replace(old, new)
    print("[OK] Fixed fetchComms - removed reference to non-existent old function.")
else:
    print("[WARN] Exact pattern not found, may need manual check.")

with open("mini_app/static/js/app_logic_part1.js", "w", encoding="utf-8") as f:
    f.write(content)
