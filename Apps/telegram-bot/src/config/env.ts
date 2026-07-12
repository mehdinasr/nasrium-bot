type Env = {
  BOT_TOKEN: string;
  NODE_ENV: "development" | "production" | string;
};

export function getEnv(): Env {
  const BOT_TOKEN = process.env.BOT_TOKEN?.trim();
  const NODE_ENV = process.env.NODE_ENV?.trim() || "development";

  if (!BOT_TOKEN || BOT_TOKEN === "PASTE_YOUR_TOKEN_HERE") {
    throw new Error("BOT_TOKEN is missing. Create .env file based on .env.example and set BOT_TOKEN.");
  }

  return { BOT_TOKEN, NODE_ENV };
}
