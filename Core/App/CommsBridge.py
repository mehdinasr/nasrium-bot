import requests

class CommsBridge:
    """CMD_966: پل زدن بین چت داخلی و تلگرام."""
    TG_BOT_TOKEN = "YOUR_BOT_TOKEN"
    TG_CHAT_ID = "YOUR_GROUP_CHAT_ID"

    @staticmethod
    def bridge_to_telegram(user_id, rank, message):
        """ارسال پیام از مینی‌اپ به تلگرام."""
        text = f"🌐 **APP CHAT**\n👤 {user_id} [{rank}]\n💬 {message}"
        # url = f"https://api.telegram.org/bot{CommsBridge.TG_BOT_TOKEN}/sendMessage"
        # requests.post(url, data={"chat_id": CommsBridge.TG_CHAT_ID, "text": text, "parse_mode": "Markdown"})
        print(f"[BRIDGE -> TG]: {text}")

    @staticmethod
    def bridge_to_app(tg_user, message):
        """ارسال پیام از تلگرام به مینی‌اپ (شبیه‌سازی)."""
        # این متد پیام را به CommsEngine.CHAT_BUFFER اضافه می‌کند
        return {"user_id": f"TG_{tg_user}", "rank": "Telegram Citizen", "text": message}
