import time

class ImperialCCTV:
    """CMD_963: سیستم نظارت سراسری بر فعالیت‌های مشکوک و مهم."""
    LOGS = [] # ذخیره ۵۰ واقعه مهم اخیر

    @staticmethod
    def log_event(event_type, u_id, description):
        entry = {
            "time": time.strftime("%H:%M:%S"),
            "type": event_type, # SWAP, ARENA_WIN, PURGE
            "u_id": u_id,
            "desc": description
        }
        ImperialCCTV.LOGS.append(entry)
        if len(ImperialCCTV.LOGS) > 50: ImperialCCTV.LOGS.pop(0)

class VirusPurge:
    """CMD_964: مینی‌گیم پاکسازی ویروس برای امنیت شبکه."""
    @staticmethod
    def calculate_purge_reward(clicks):
        # پاداش بر اساس سرعت پاکسازی
        return clicks * 50

class EncryptedComms:
    """CMD_965: ارتباطات رمزگذاری شده مخصوص لژیون‌ها."""
    MESSAGES = {} # {legion_name: [messages]}

    @staticmethod
    def send_private(legion_name, u_id, text):
        if legion_name not in EncryptedComms.MESSAGES:
            EncryptedComms.MESSAGES[legion_name] = []
        EncryptedComms.MESSAGES[legion_name].append({
            "sender": u_id,
            "text": text,
            "time": time.strftime("%H:%M")
        })
