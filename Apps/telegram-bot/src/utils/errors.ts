import type { Bot, Context } from "grammy";

export function registerErrorHandler(bot: Bot<Context>) {
  bot.catch((err) => {
    const ctx = err.ctx as Context | undefined;
    const updateId = (ctx as any)?.update?.update_id;
    console.error("[NASRIUM] Bot error", { updateId, error: err.error });
  });
}
