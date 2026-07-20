import { Bot } from "grammy";
import dotenv from "dotenv";
import { HttpsProxyAgent } from "https-proxy-agent";

dotenv.config();

const token = process.env.BOT_TOKEN;
console.log("Token length:", token ? token.length : "NO TOKEN");

const agent = new HttpsProxyAgent("http://127.0.0.1:56506");

const bot = new Bot(token, {
    client: {
        baseFetchConfig: {
            agent: agent,
        },
    },
});

console.log("Calling getMe()...");
try {
    const me = await bot.api.getMe();
    console.log("SUCCESS! Bot username:", me.username);
} catch (err) {
    console.log("FAILED:", err.message);
    console.log(err);
}
