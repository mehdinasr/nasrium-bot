import { Bot, InlineKeyboard } from "grammy";
import dotenv from "dotenv";
import { HttpsProxyAgent } from "https-proxy-agent";

dotenv.config();

const token = process.env.BOT_TOKEN;
if (!token || token === "" || token.includes("YOUR_")) {
    console.error("خطا: توکن ربات در فایل .env تنظیم نشده است!");
    process.exit(1);
}

// تنظیم پروکسی برای ارتباط با سرورهای تلگرام در صورت نیاز
const agent = new HttpsProxyAgent("http://127.0.0.1:8080");
const bot = new Bot(token, {
    client: {
        baseFetchConfig: {
            agent: agent,
        },
    },
});

bot.command("start", async (ctx) => {
    const username = ctx.from?.first_name || "فرمانده";
    
    // متصل کردن دکمه وب‌اپ به آدرس پروداکشن سرور شما در Railway
    const keyboard = new InlineKeyboard()
        .webApp("🚀 ورود به پلتفرم مالی NASRIUM", "https://nasrium-bot-production.up.railway.app/")
        .row()
        .url("📢 کانال رسمی", "https://t.me/nasrium")
        .url("💬 اتاق جنگ (گفتگو)", "https://t.me/nasrium_chat");

    const welcomeMessage = `سلام ${username}! به ستاد فرماندهی و اکوسیستم مالی نصریوم خوش آمدید.\n\n<b>NASRIUM (NSM)</b>\nسیستم یکپارچه مالی، خزانه‌داری ملی و مدیریت گره‌های شبکه فعال است. تمام موتورهای تسویه و برداشت در وضعیت آماده‌باش قرار دارند.\n\n🔹 از دکمه زیر برای ورود به پلتفرم و مدیریت ولت خود استفاده کنید:`;

    await ctx.reply(welcomeMessage, {
        parse_mode: "HTML",
        reply_markup: keyboard
    });
});

bot.on("message", async (ctx) => {
    await ctx.reply("درخواست دریافت شد. برای دسترسی به پنل مالی، دستور /start را ارسال کنید.");
});

bot.catch((err) => {
    console.error("خطا در پردازش پیام ربات:", err.error);
});

console.log("🚀 [NASRIUM BOT] ربات تلگرام در حال راه‌اندازی و اتصال به مینی‌اپ است...");
bot.start();
