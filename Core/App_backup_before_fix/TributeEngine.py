import time
from datetime import datetime, timedelta

class TributeEngine:
    # پاداش‌های روزانه (NSM Soft, Energy)
    REWARDS = {
        1: (1000, 10), 2: (2000, 15), 3: (3500, 20),
        4: (5000, 25), 5: (7500, 30), 6: (10000, 40),
        7: (25000, 100) # روز هفتم: جایزه بزرگ
    }

    @staticmethod
    def process_tribute(player_data):
        now = datetime.utcnow()
        last_claim_str = player_data.get("last_tribute_date")
        streak = player_data.get("tribute_streak", 0)

        if last_claim_str:
            last_claim = datetime.fromisoformat(last_claim_str)
            diff = now - last_claim
            
            if diff < timedelta(hours=24):
                return False, "The next Imperial Tribute is not yet ready.", streak
            
            if diff > timedelta(hours=48):
                streak = 0 # زنجیره قطع شد
        
        streak = (streak % 7) + 1
        nsm_reward, energy_reward = TributeEngine.REWARDS[streak]
        
        player_data["nsm_soft"] = player_data.get("nsm_soft", 0) + nsm_reward
        player_data["energy"] = player_data.get("energy", 0) + energy_reward
        player_data["tribute_streak"] = streak
        player_data["last_tribute_date"] = now.isoformat()
        
        return True, f"Tribute Received: {nsm_reward} NSM & {energy_reward} Energy.", streak
