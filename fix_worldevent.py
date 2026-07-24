with open("mini_app/static/js/app_logic_part7.js", "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace(chr(0xFEFF), "")

old = """    const event = data.current_event;

    let banner = document.getElementById('world-event-banner');
    if(!banner) {
        banner = document.createElement('div');
        banner.id = 'world-event-banner';
        banner.style = "position:fixed; top:0; left:0; width:100%; background:linear-gradient(to right, #6a11cb, #2575fc); color:white; font-size:0.6em; text-align:center; padding:5px; z-index:200002; font-weight:bold; letter-spacing:1px;";
        document.body.appendChild(banner);
    }
    banner.innerHTML = `🌍 WORLD EVENT: ${event.name} (${event.effect})`;"""

new = """    const event = data.current_event;
    if(!event) return;

    let banner = document.getElementById('world-event-banner');
    if(!banner) {
        banner = document.createElement('div');
        banner.id = 'world-event-banner';
        banner.style = "position:fixed; top:0; left:0; width:100%; background:linear-gradient(to right, #6a11cb, #2575fc); color:white; font-size:0.6em; text-align:center; padding:5px; z-index:200002; font-weight:bold; letter-spacing:1px;";
        document.body.appendChild(banner);
    }
    banner.innerHTML = `🌍 WORLD EVENT: ${event.name} (${event.effect})`;"""

if old in content:
    content = content.replace(old, new)
    print("[OK] Fixed updateWorldEvent - defensive check for current_event.")
else:
    print("[WARN] Exact pattern not found, may need manual check.")

with open("mini_app/static/js/app_logic_part7.js", "w", encoding="utf-8") as f:
    f.write(content)
