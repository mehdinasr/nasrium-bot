import time

class LoyaltyEngine:
    # تعریف پاداش‌های ۷ روزه
    REWARDS = {
        1: {"gold": 5000, "nsm": 0, "scraps": 0},
        2: {"gold": 8000, "nsm": 100, "scraps": 0},
        3: {"gold": 12000, "nsm": 300, "scraps": 10},
        4: {"gold": 15000, "nsm": 500, "scraps": 15},
        5: {"gold": 20000, "nsm": 800, "scraps": 20},
        6: {"gold": 30000, "nsm": 1200, "scraps": 30},
        7: {"gold": 50000, "nsm": 2000, "scraps": 50}
    }

    @staticmethod
    def check_claim_eligibility(player_data):
        last_claim = player_data.get("last_daily_claim", 0)
        now = time.time()
        
        # بررسی اینکه آیا ۲۴ ساعت گذشته است؟
        if now - last_claim < 86400:
            return False, int(86400 - (now - last_claim))
        return True, 0

    @staticmethod
    def process_claim(player_data):
        can_claim, time_left = LoyaltyEngine.check_claim_eligibility(player_data)
        if not can_claim:
            return False, f"Next calibration in {time_left // 3600}h.", None

        streak = player_data.get("daily_streak", 0)
        last_claim = player_data.get("last_daily_claim", 0)
        
        # اگر بیش از ۴۸ ساعت گذشته باشد، استریک ریست می‌شود
        if time.time() - last_claim > 172800:
            streak = 0
            
        new_streak = (streak % 7) + 1
        reward = LoyaltyEngine.REWARDS[new_streak]
        
        # اعمال پاداش‌ها
        player_data["gold"] += reward["gold"]
        player_data["nsm_soft"] += reward["nsm"]
        player_data["scraps"] = player_data.get("scraps", 0) + reward["scraps"]
        player_data["last_daily_claim"] = time.time()
        player_data["daily_streak"] = new_streak
        
        return True, f"Day {new_streak} Calibrated! Resources Synchronized.", reward
