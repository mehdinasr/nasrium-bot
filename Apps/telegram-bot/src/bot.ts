import { Bot } from "grammy";
import { getEnv } from "./config/env.js";
import { registerStartHandler } from "./handlers/start.js";
import { registerTextHandler } from "./handlers/text.js";
import { registerErrorHandler } from "./utils/errors.js";

export function createBot() {
  const env = getEnv();
  const bot = new Bot(env.BOT_TOKEN);

  registerStartHandler(bot);
  registerTextHandler(bot);
  registerErrorHandler(bot);

  return bot;
}
