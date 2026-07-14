class SentinelAIEngine:
    @staticmethod
    def analyze_behavior(player_data):
        # تحلیل پارامترهای رفتاری برای تشخیص انسان از ربات
        trust_score = 100
        
        # ۱. بررسی تنوع فعالیت (ربات‌ها معمولاً فقط یک کار تکراری انجام می‌دهند)
        activity_diversity = len(player_data.get("completed_daily_missions", []))
        if activity_diversity < 2: trust_score -= 20
        
        # ۲. بررسی تاریخچه تراکنش‌ها
        tx_count = len(player_data.get("withdraw_history", []))
        if tx_count > 10 and player_data.get("town_hall_level", 1) < 3:
            trust_score -= 40 # مشکوک به سوءاستفاده مالی
            
        # ۳. بررسی اتصال ولت
        if not player_data.get("ton_wallet"):
            trust_score -= 10
            
        return max(0, trust_score)

    @staticmethod
    def get_risk_status(score):
        if score > 80: return "VERIFIED HUMAN", "#0f0"
        if score > 50: return "NEURAL ANOMALY", "#f1c40f"
        return "BOT PATTERN DETECTED", "#f00"
