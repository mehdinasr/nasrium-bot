with open("index.js", "r", encoding="utf-8") as f:
    lines = f.readlines()

# حذف خط import http از جای فعلیش (خط شماره 6 ایندکس 5)
http_import_line = lines.pop(5)

# اضافه کردنش بعد از import دوم (بعد از dotenv import) یعنی ایندکس 2
lines.insert(2, http_import_line)

with open("index.js", "w", encoding="utf-8") as f:
    f.writelines(lines)

print("Import moved to top")
