with open("mini_app/index.html", "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace(chr(0xFEFF), "")

old_script_tag = '<script src="https://telegram.org/js/telegram-web-app.js"></script>'
new_script_tag = old_script_tag + '\n    <script src="static/js/i18n_loader.js"></script>'

if 'i18n_loader.js' not in content:
    content = content.replace(old_script_tag, new_script_tag, 1)
    print("[OK] i18n_loader.js script tag added.")
else:
    print("[INFO] Script tag already exists.")

old_fn_start = "(async function loadSequentially() {\n    const parts = [];"
new_fn_start = "(async function loadSequentially() {\n    await window.NASRIUM_I18N.init();\n    const parts = [];"

if "await window.NASRIUM_I18N.init();" not in content:
    content = content.replace(old_fn_start, new_fn_start, 1)
    print("[OK] Added await for i18n init before loading parts.")
else:
    print("[INFO] Await call already exists.")

with open("mini_app/index.html", "w", encoding="utf-8") as f:
    f.write(content)
