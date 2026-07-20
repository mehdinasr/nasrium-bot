import { Bot, InlineKeyboard } from "grammy";
import dotenv from "dotenv";
import { HttpsProxyAgent } from "https-proxy-agent";

dotenv.config();
const token = process.env.BOT_TOKEN;
if (!token || token === "" || token.includes("YOUR_")) {
    console.error("خطا: توکن ربات در فایل .env تنظیم نشده است!");
    process.exit(1);
}

const agent = new HttpsProxyAgent("http://127.0.0.1:56506");
const bot = new Bot(token, {
    client: {
        baseFetchConfig: {
            agent: agent,
        },
    },
});

bot.command("start", async (ctx) => {
    const username = ctx.from?.first_name || "دوست عزیز";

    const keyboard = new InlineKeyboard()
        .webApp("🚀 ورود به اپ NASRIUM", "https://neat-badgers-rhyme.loca.lt")
        .row()
        .url("📢 عضویت در کانال ما", "https://t.me/NasriumOfficial")
        .url("💬 گروه گفتگو", "https://t.me/+MoDICv3piIFhNGFk");

    const welcomeMessage = `سلام ${username}! به ربات رسمی نصریوم خوش آمدید.

<b>NASRIUM (NSM)</b> یک اکوسیستم دیجیتال است که با هدف ایجاد فرصت‌های واقعی برای اعضای خود طراحی شده است.

<b>امکانات ربات:</b>
🔹 ورود به اپ اصلی و کیف پول (WebApp)
🔹 دریافت اطلاعات توکن NSM و پروژه
🔹 دسترسی سریع به کانال و گروه رسمی

از دکمه‌های زیر برای شروع استفاده کنید:`;

    await ctx.reply(welcomeMessage, {
        parse_mode: "HTML",
        reply_markup: keyboard
    });
});

bot.on("message", async (ctx) => {
    await ctx.reply("پیام شما دریافت شد. برای مشاهده‌ی امکانات ربات، دستور /start را ارسال کنید.");
});

bot.catch((err) => {
    console.error("خطا در پردازش پیام:");
    console.error(err.error);
});

console.log("🚀 [NASRIUM] ربات در حال راه‌اندازی است...");
bot.start();


