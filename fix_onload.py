with open("mini_app/static/js/app_logic_part1.js", "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace(chr(0xFEFF), "")

old = """window.onload = () => {
    initGame();
    // Ignition Animation
    setTimeout(() => { document.getElementById('ignition-overlay').style.opacity = '0'; }, 2000);
};"""

new = """initGame();
setTimeout(() => { document.getElementById('ignition-overlay').style.opacity = '0'; }, 2000);"""

if old in content:
    content = content.replace(old, new)
    print("[OK] Fixed: initGame() now called directly instead of via window.onload")
else:
    print("[WARN] Exact pattern not found - manual check needed")

with open("mini_app/static/js/app_logic_part1.js", "w", encoding="utf-8") as f:
    f.write(content)
