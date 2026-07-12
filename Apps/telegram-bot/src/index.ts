import "dotenv/config";
import { createBot } from "./bot.js";

async function main() {
  const bot = createBot();
  console.log("[NASRIUM] Bot starting (long polling) ...");
  await bot.start();
}

main().catch((err) => {
  console.error("[NASRIUM] Fatal error:", err);
  process.exit(1);
});
