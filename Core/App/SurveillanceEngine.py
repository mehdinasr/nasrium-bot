import random

class SurveillanceEngine:
    @staticmethod
    def get_sector_volatility():
        # در نسخه نهایی، این داده‌ها از دیتابیس نبردهای اخیر استخراج می‌شود
        # فعلاً شبیه‌سازی برای ۹ بخش (S1 تا S9)
        heatmap = {}
        for i in range(1, 10):
            sector_id = f"S{i}"
            intensity = random.randint(1, 100)
            
            status = "STABLE"
            if intensity > 80: status = "CRITICAL"
            elif intensity > 40: status = "ACTIVE"
            
            heatmap[sector_id] = {
                "intensity": intensity,
                "status": status,
                "loot_bonus": 1.0 + (intensity / 500) # تا ۲۰٪ بونوس لوت در مناطق جنگی
            }
        return heatmap
