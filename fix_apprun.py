with open("mini_api.py", "r", encoding="utf-8") as f:
    lines = f.readlines()

last_line = lines[-1].strip()
if last_line.startswith("app.run("):
    lines = lines[:-1]
    print("Removed orphan app.run line:", repr(last_line))

if lines and not lines[-1].endswith("\n"):
    lines[-1] += "\n"

lines.append("    app.run(host=" + chr(34) + "0.0.0.0" + chr(34) + ", port=port)\n")

with open("mini_api.py", "w", encoding="utf-8") as f:
    f.writelines(lines)

print("Fixed. New last 5 lines:")
print("".join(lines[-5:]))
