with open("mini_api.py", "r", encoding="utf-8") as f:
    lines = f.readlines()

lines[18] = "if __name__ == " + chr(34) + "__main__" + chr(34) + ":\n"
lines[19] = "    port = int(os.environ.get(" + chr(34) + "PORT" + chr(34) + ", 5000))\n"
lines.append("    app.run(host=" + chr(34) + "0.0.0.0" + chr(34) + ", port=port)\n")

with open("mini_api.py", "w", encoding="utf-8") as f:
    f.writelines(lines)

print("Done")
