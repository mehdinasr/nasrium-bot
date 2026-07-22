with open("index.js", "r", encoding="utf-8") as f:
    lines = f.readlines()

# خط 28 (ایندکس 27) رو مستقیم جایگزین می‌کنیم
lines[27] = "    const welcomeMessage = " + chr(96) + "\n"

with open("index.js", "w", encoding="utf-8") as f:
    f.writelines(lines)

print("Done - line 28 fixed")
