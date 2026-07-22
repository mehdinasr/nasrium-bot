with open("index.html", "r", encoding="utf-8") as f:
    content = f.read()

import re
content = re.sub(r'(\s*<script src="static/js/app_logic_part\d+\.js"></script>\n?)+', '', content)

loader_script = """
<script>
(async function loadSequentially() {
    const parts = [];
    for (let i = 1; i <= 15; i++) {
        parts.push(`static/js/app_logic_part${i}.js`);
    }
    for (const src of parts) {
        await new Promise((resolve, reject) => {
            const s = document.createElement("script");
            s.src = src;
            s.onload = resolve;
            s.onerror = reject;
            document.body.appendChild(s);
        });
    }
    console.log("All parts loaded sequentially");
})();
</script>
"""

content = content.replace("</body>", loader_script + "</body>")

with open("index.html", "w", encoding="utf-8") as f:
    f.write(content)

print("index.html updated with sequential loader")
