import time
import hashlib

class CipherEngine:
    # آیکون‌های موجود در سیستم
    SYMBOLS = ["WAR", "GOLD", "TECH", "AI", "SHIELD"]
    
    @staticmethod
    def get_daily_code():
        # تولید رمز بر اساس تاریخ روز (ثابت برای همه بازیکنان در ۲۴ ساعت)
        today = time.strftime("%Y-%m-%d")
        seed = int(hashlib.md5(today.encode()).hexdigest(), 16)
        
        # انتخاب ۳ نماد تصادفی
        import random
        random.seed(seed)
        return random.sample(CipherEngine.SYMBOLS, 3)

    @staticmethod
    def verify_attempt(player_data, attempt_list):
        if player_data.get("daily_cipher_solved", False):
            # بررسی اینکه آیا امروز قبلاً حل شده؟ (نیاز به فیلد تاریخ در دیتابیس واقعی)
            pass 

        correct_code = CipherEngine.get_daily_code()
        if attempt_list == correct_code:
            return True, "Neural Cipher Decoded! 50k Gold and 500 IXP granted."
        return False, "Sequence incorrect. Neural sync failed."
