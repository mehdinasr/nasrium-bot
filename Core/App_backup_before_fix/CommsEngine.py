from datetime import datetime

class CommsEngine:
    """
    مدیریت پیام‌های سراسری در امپراتوری نصریوم.
    """
    CHAT_BUFFER = [] # ذخیره ۱۰۰ پیام آخر در حافظه (برای سرعت بالا)
    MAX_BUFFER = 100

    @staticmethod
    def send_message(u_id, rank, text):
        if not text or len(text) > 200:
            return False, "Message too long or empty."
        
        message = {
            "user_id": u_id,
            "rank": rank,
            "text": text,
            "time": datetime.now().strftime("%H:%M")
        }
        
        CommsEngine.CHAT_BUFFER.append(message)
        
        # حفظ ظرفیت بافر
        if len(CommsEngine.CHAT_BUFFER) > CommsEngine.MAX_BUFFER:
            CommsEngine.CHAT_BUFFER.pop(0)
            
        return True, "Signal transmitted."

    @staticmethod
    def get_messages():
        return CommsEngine.CHAT_BUFFER
