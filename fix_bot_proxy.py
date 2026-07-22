with open("bot/src/index.js", "r", encoding="utf-8") as f:
    lines = f.readlines()

# خط 3 (ایندکس 2) - حذف import پروکسی
lines[2] = ""

# خطهای 13 تا 21 (ایندکس 12 تا 20) - جایگزینی با نسخهی ساده بدون پروکسی
for i in range(12, 21):
    lines[i] = ""

lines[12] = "const bot = new Bot(token);\n"

with open("bot/src/index.js", "w", encoding="utf-8") as f:
    f.writelines(lines)

print("Proxy code removed")
