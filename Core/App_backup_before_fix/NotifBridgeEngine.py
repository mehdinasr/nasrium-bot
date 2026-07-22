import requests

class NotifBridgeEngine:
    # این توکن باید از متغیرهای محیطی خوانده شود
    BOT_TOKEN = "YOUR_BOT_TOKEN_HERE" 

    @staticmethod
    def send_telegram_alert(chat_id, message, priority="NORMAL"):
        if priority != "CRITICAL":
            return True, "Message queued for next login (Non-critical)."

        # شبیه‌سازی ارسال به API تلگرام
        # url = f"https://api.telegram.org/bot{NotifBridgeEngine.BOT_TOKEN}/sendMessage"
        # payload = {"chat_id": chat_id, "text": f"🚨 IMPERIAL ALERT: {message}", "parse_mode": "HTML"}
        
        return True, f"Telegram Push transmitted to {chat_id}."

    @staticmethod
    def format_raid_alert(attacker_id, loot):
        return f"Commander! Your base was raided by <b>{attacker_id}</b>. Resources lost: {loot} Gold."
