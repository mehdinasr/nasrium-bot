with open("index.js", "r", encoding="utf-8") as f:
    content = f.read()

old_import = "import { SocksProxyAgent } from " + chr(34) + "socks-proxy-agent" + chr(34) + ";"
new_import = "import { ProxyAgent, setGlobalDispatcher } from " + chr(34) + "undici" + chr(34) + ";"

if old_import in content:
    content = content.replace(old_import, new_import, 1)
    print("import replaced")
else:
    print("old import not found - might already be changed")

old_bot_line1 = "const agent = new SocksProxyAgent(" + chr(34) + "socks5h://127.0.0.1:56505" + chr(34) + ");"
old_bot_line2 = "const bot = new Bot(token, { client: { baseFetchConfig: { agent: agent } } });"
old_bot = old_bot_line1 + chr(10) + old_bot_line2

new_bot_line1 = "setGlobalDispatcher(new ProxyAgent(" + chr(34) + "http://127.0.0.1:56506" + chr(34) + "));"
new_bot_line2 = "const bot = new Bot(token);"
new_bot = new_bot_line1 + chr(10) + new_bot_line2

if old_bot in content:
    content = content.replace(old_bot, new_bot, 1)
    print("bot init replaced")
else:
    print("old bot init not found - checking current state")

with open("index.js", "w", encoding="utf-8") as f:
    f.write(content)

print("Done")
