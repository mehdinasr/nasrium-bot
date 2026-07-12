import type { Bot, Context } from "grammy";

export function registerTextHandler(bot: Bot<Context>) {
  bot.on("message:text", async (ctx) => {
    await ctx.reply("پیام شما دریافت شد. برای شروع /start را بزنید.");
  });
}
