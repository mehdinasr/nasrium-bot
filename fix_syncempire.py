with open("mini_app/static/js/app_logic_part7.js", "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace(chr(0xFEFF), "")

old = "data.new_badges.forEach(badge => {"
new = "(data.new_badges || []).forEach(badge => {"

if old in content:
    content = content.replace(old, new)
    print("[OK] Fixed syncEmpireState - defensive check for new_badges.")
else:
    print("[WARN] Pattern not found.")

with open("mini_app/static/js/app_logic_part7.js", "w", encoding="utf-8") as f:
    f.write(content)
