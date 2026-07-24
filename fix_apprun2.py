with open("mini_api.py", "r", encoding="utf-8") as f:
    lines = f.readlines()

# حذف app.run اشتباهی که به انتهای فایل اضافه شده بود
if lines[-1].strip().startswith("app.run("):
    lines = lines[:-1]
    print("Removed misplaced app.run from end of file")

# پیدا کردن خط port = ... و اضافه کردن app.run درست بعدش
for i, line in enumerate(lines):
    if line.strip().startswith("port = int(os.environ.get"):
        lines.insert(i + 1, "    app.run(host=" + chr(34) + "0.0.0.0" + chr(34) + ", port=port)\n")
        print("Inserted app.run after line:", i + 1)
        break

with open("mini_api.py", "w", encoding="utf-8") as f:
    f.writelines(lines)

print("Last 5 lines now:")
print("".join(lines[-5:]))
