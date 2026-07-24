with open("mini_app/static/js/app_logic_part8.js", "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace(chr(0xFEFF), "")

old = """    const event = data.event;

    if(event.is_active) {"""

new = """    const event = data.event;
    if(!event) return;

    if(event.is_active) {"""

if old in content:
    content = content.replace(old, new)
    print("[OK] Fixed startBigBangTicker - defensive check for event.")
else:
    print("[WARN] Exact pattern not found, may need manual check.")

with open("mini_app/static/js/app_logic_part8.js", "w", encoding="utf-8") as f:
    f.write(content)
