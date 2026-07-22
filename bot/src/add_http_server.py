with open("index.js", "r", encoding="utf-8") as f:
    lines = f.readlines()

http_server_code = [
    "\n",
    "import http from " + chr(34) + "http" + chr(34) + ";\n",
    "const port = process.env.PORT || 3000;\n",
    "http.createServer((req, res) => { res.writeHead(200); res.end(" + chr(34) + "Bot is running" + chr(34) + "); }).listen(port, () => {\n",
    "    console.log(" + chr(34) + "Health check server listening on port " + chr(34) + " + port);\n",
    "});\n"
]

# اضافه کردن بعد از خط 4 (dotenv.config();)
insert_pos = 4
for i, line in enumerate(http_server_code):
    lines.insert(insert_pos + i, line)

with open("index.js", "w", encoding="utf-8") as f:
    f.writelines(lines)

print("HTTP health check server added")
