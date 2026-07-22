import re
with open("index.js", "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace("const welcomeMessage =\n", "const welcomeMessage = `\n", 1)
content = re.sub(r"\n;\n", "`;\n", content, count=1)

with open("index.js", "w", encoding="utf-8") as f:
    f.write(content)

print("Fixed!")
