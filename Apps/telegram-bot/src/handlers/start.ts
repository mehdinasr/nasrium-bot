import type { Bot, Context } from "grammy";

export function registerStartHandler(bot: Bot<Context>) {
  bot.command("start", async (ctx) => {
    const name = ctx.from?.first_name ?? "دوست عزیز";
    await ctx.reply(`سلام ${name}!`);
  });
}
