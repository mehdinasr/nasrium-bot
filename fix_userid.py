with open("mini_app/static/js/app_logic_part1.js", "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace(chr(0xFEFF), "")

old = 'const userId = "COMMANDER_MEHDI_ID"; // Temporary holder'
new = '''const userId = (function() {
    try {
        const tgUser = window.Telegram?.WebApp?.initDataUnsafe?.user;
        if (tgUser && tgUser.id) {
            return String(tgUser.id);
        }
    } catch (e) {
        console.warn("[userId] Could not read Telegram user id, using fallback.");
    }
    return "COMMANDER_MEHDI_ID"; // Fallback for testing outside Telegram
})();'''

if old in content:
    content = content.replace(old, new)
    print("[OK] Fixed userId - now reads real Telegram user id first.")
else:
    print("[WARN] Exact pattern not found, may need manual check.")

with open("mini_app/static/js/app_logic_part1.js", "w", encoding="utf-8") as f:
    f.write(content)
