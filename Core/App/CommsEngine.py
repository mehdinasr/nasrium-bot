import time

class CommsEngine:
    # حافظه موقت برای پیام‌های جهانی
    MESSAGE_BUFFER = [
        {"user": "SYSTEM", "text": "Nasrium Global Frequency Initialized...", "time": time.time()}
    ]
    MAX_BUFFER = 50

    @staticmethod
    def broadcast_message(username, text):
        msg = {
            "user": username,
            "text": text,
            "time": time.time()
        }
        CommsEngine.MESSAGE_BUFFER.append(msg)
        
        # حفظ محدودیت حافظه
        if len(CommsEngine.MESSAGE_BUFFER) > CommsEngine.MAX_BUFFER:
            CommsEngine.MESSAGE_BUFFER.pop(0)
        return True

    @staticmethod
    def get_feed():
        return CommsEngine.MESSAGE_BUFFER
