with open("index.html", "r", encoding="utf-8") as f:
    content = f.read()

old_script = '<script src="static/js/app_logic.min.js"></script>'
new_scripts = "\n".join([f'    <script src="static/js/app_logic_part{i}.js"></script>' for i in range(1, 16)])

if old_script in content:
    content = content.replace(old_script, new_scripts)
    print("Replaced .min.js reference")
else:
    old_script2 = '<script src="static/js/app_logic.js"></script>'
    if old_script2 in content:
        content = content.replace(old_script2, new_scripts)
        print("Replaced .js reference")
    else:
        print("Neither script tag found - manual check needed")

with open("index.html", "w", encoding="utf-8") as f:
    f.write(content)
