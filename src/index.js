import { Bot, InlineKeyboard } from "grammy";
import dotenv from "dotenv";

// بارگذاری تنظیمات محیطی
dotenv.config();

const token = process.env.BOT_TOKEN;

if (!token || token === "" || token.includes("YOUR_")) {
    console.error("❌ خطا: توکن ربات تلگرام در فایل .env به درستی تنظیم نشده است!");
    process.exit(1);
}

// مقداردهی اولیه ربات با فریمورک استاندارد gramY
const bot = new Bot(token);

// هندلر دستور /start (اولین تعامل کاربر با اکوسیستم NASRIUM)
bot.command("start", async (ctx) => {
    const username = ctx.from?.first_name || "کاربر گرامی";
    
    // طراحی کیبورد شیشه‌ای مدرن برای ورود به بازی (در آینده به WebApp متصل می‌شود)
    const keyboard = new InlineKeyboard()
        .webApp("🎮 ورود به بازی NASRIUM", "https://nasrium.ir") // لینک تستی، بعداً با وب‌اپ جایگزین می‌شود
        .row()
        .url("📢 عضویت در کانال رسمی", "https://t.me/nasrium")
        .url("👥 گروه گفتگو", "https://t.me/nasrium_chat");

    const welcomeMessage = 
🌟 **به اکوسیستم جهانی NASRIUM خوش آمدید!** 🌟

سلام \ عزیز! به دنیای بازی‌های استراتژیک و نسل جدید ارزهای دیجیتال قدم گذاشتید.

**NASRIUM (NSM)** فقط یک توکن معمولی نیست؛ یک اکوسیستم و امپراتوری دیجیتال است که قدرت آن با بازی و فعالیت شما شکل می‌گیرد.

**قابلیت‌های فعلی:**
⚔️ ساخت قلمرو و تدارک ارتش (به‌زودی)
💎 استخراج توکن‌های NSM از طریق مینی‌گیم
🏆 رتبه‌بندی جهانی و ایردراپ بر اساس شایستگی

برای شروع بازی و استخراج اولین توکن‌های خود، روی دکمه زیر کلیک کنید:
;

    await ctx.reply(welcomeMessage, {
        parse_mode: "Markdown",
        reply_markup: keyboard
    });
});

// هندلر پیام‌های متنی ساده
bot.on("message", async (ctx) => {
    await ctx.reply("پیام شما دریافت شد. لطفاً برای شروع تعامل با اکوسیستم، دستور /start را ارسال کنید یا دکمه بازی را فشار دهید.");
});

// ثبت خطاها به صورت کاملاً حرفه‌ای و پایدار
bot.catch((err) => {
    const ctx = err.ctx;
    console.error(❌ خطا در حین پردازش آپدیت \:);
    console.error(err.error);
});

// راه‌اندازی ربات
console.log("🚀 [NASRIUM] ربات با موفقیت فعال شد و در حال گوش دادن به پیام‌ها است...");
bot.start();

// Railway Health Check
app.get('/', (req, res) => {
    res.status(200).json({ status: 'ok', service: 'nasrium-bot' });
});


