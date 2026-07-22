import time
from datetime import datetime

class StreakEngine:
    BASE_GOLD_REWARD = 1000
    BASE_NSM_REWARD = 20

    @staticmethod
    def process_checkin(player_data):
        last_checkin_str = player_data.get("last_checkin_date", "1970-01-01")
        current_date_str = datetime.now().strftime("%Y-%m-%d")
        
        if last_checkin_str == current_date_str:
            return False, "Already checked in today.", None

        # بررسی اینکه آیا دیروز وارد شده یا خیر (برای حفظ زنجیره)
        last_date = datetime.strptime(last_checkin_str, "%Y-%m-%d")
        delta = (datetime.now() - last_date).days
        
        current_streak = player_data.get("streak_count", 0)
        
        if delta == 1:
            # زنجیره حفظ شد
            new_streak = current_streak + 1
        else:
            # زنجیره قطع شد یا اولین بار است
            new_streak = 1
            
        # محاسبه پاداش پلکانی (تا سقف 7 روز)
        multiplier = min(new_streak, 7)
        reward_gold = StreakEngine.BASE_GOLD_REWARD * multiplier
        reward_nsm = StreakEngine.BASE_NSM_REWARD * multiplier
        
        player_data["gold"] = player_data.get("gold", 0) + reward_gold
        player_data["nsm_soft"] = player_data.get("nsm_soft", 0) + reward_nsm
        player_data["streak_count"] = new_streak
        player_data["last_checkin_date"] = current_date_str
        
        rewards = {"gold": reward_gold, "nsm": reward_nsm, "streak": new_streak}
        return True, f"Day {new_streak} Check-in Complete!", rewards
