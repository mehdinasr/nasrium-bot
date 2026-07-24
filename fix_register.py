with open("mini_app/static/js/app_logic_part1.js", "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace(chr(0xFEFF), "")

old = """async function initGame() {
    console.log("Nasrium Sovereign Core Resynced.");
    loadWeather();
    loadEmpirePulse();
    loadWarp();
}"""

new = """async function initGame() {
    console.log("Nasrium Sovereign Core Resynced.");
    try {
        await fetch("/api/user/register", {
            method: "POST",
            headers: {"Content-Type": "application/json"},
            body: JSON.stringify({ user_id: userId })
        });
    } catch (e) {
        console.error("[initGame] Failed to register user:", e);
    }
    loadWeather();
    loadEmpirePulse();
    loadWarp();
}"""

if old in content:
    content = content.replace(old, new)
    print("[OK] Added automatic user registration on game start.")
else:
    print("[WARN] Exact pattern not found, may need manual check.")

with open("mini_app/static/js/app_logic_part1.js", "w", encoding="utf-8") as f:
    f.write(content)
