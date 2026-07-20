with open("index.js", "r", encoding="utf-8") as f:
    lines = f.readlines()

# اضافه کردن import پروکسی بعد از خط 2 (import dotenv)
proxy_import = "import { ProxyAgent, setGlobalDispatcher } from " + chr(34) + "undici" + chr(34) + ";" + chr(10)
lines.insert(2, proxy_import)

# حالا خط "const bot = new Bot(token);" یک خط جلوتر رفته (چون یک خط اضافه کردیم)
for i, line in enumerate(lines):
    if line.strip() == "const bot = new Bot(token);":
        proxy_setup = "setGlobalDispatcher(new ProxyAgent(" + chr(34) + "http://127.0.0.1:56506" + chr(34) + "));" + chr(10)
        lines.insert(i, proxy_setup)
        print("Found and inserted proxy setup before line", i+1)
        break

with open("index.js", "w", encoding="utf-8") as f:
    f.writelines(lines)

print("Done")
