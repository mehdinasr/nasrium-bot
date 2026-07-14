class GoldenAgeEngine:
    # وضعیت شکوفایی جهانی (در دیتابیس واقعی نگهداری می‌شود)
    GLOBAL_STATS = {
        "prosperity_score": 75, # از ۱۰۰
        "is_active": False,
        "bonus_multiplier": 1.15
    }

    @staticmethod
    def get_status():
        # اگر امتیاز بالای ۱۰۰ برود، عصر طلایی فعال می‌شود
        if GoldenAgeEngine.GLOBAL_STATS["prosperity_score"] >= 100:
            GoldenAgeEngine.GLOBAL_STATS["is_active"] = True
            GoldenAgeEngine.GLOBAL_STATS["bonus_multiplier"] = 1.25
        else:
            GoldenAgeEngine.GLOBAL_STATS["is_active"] = False
            GoldenAgeEngine.GLOBAL_STATS["bonus_multiplier"] = 1.0
        
        return GoldenAgeEngine.GLOBAL_STATS

    @staticmethod
    def contribute_prosperity(amount):
        # فعالیت‌های بازیکنان امتیاز جهانی را بالا می‌برد
        GoldenAgeEngine.GLOBAL_STATS["prosperity_score"] += amount
        if GoldenAgeEngine.GLOBAL_STATS["prosperity_score"] > 100:
            GoldenAgeEngine.GLOBAL_STATS["prosperity_score"] = 100
        return True
