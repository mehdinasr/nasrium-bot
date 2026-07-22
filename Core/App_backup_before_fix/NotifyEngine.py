import requests

class NotifyEngine:
    """
    ارسال اعلان‌های سیستمی به کاربران از طریق Bot API تلگرام.
    """
    BOT_TOKEN = "YOUR_BOT_TOKEN_HERE" # در فاز نهایی توسط فرمانده ست می‌شود

    @staticmethod
    def send_push(chat_id, message):
        """
        ارسال پیام به چت آیدی کاربر.
        """
        # در اینجا متد ارسال واقعی به تلگرام شبیه‌سازی می‌شود
        # url = f"https://api.telegram.org/bot{NotifyEngine.BOT_TOKEN}/sendMessage"
        # payload = {"chat_id": chat_id, "text": f"🏛️ NASRIUM ALERT:\n\n{message}", "parse_mode": "HTML"}
        
        print(f"[PUSH SENT TO {chat_id}]: {message}")
        return True

    @staticmethod
    def check_mining_completion(player_data):
        # منطق بررسی اینکه آیا استخراج تمام شده و نیاز به نوتیف دارد یا خیر
        if player_data.get("is_mining") and player_data.get("notified") == False:
            # بررسی زمان (فرضی)
            return True
        return False
