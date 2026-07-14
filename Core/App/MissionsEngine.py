import time

class MissionsEngine:
    # تعریف مخزن ماموریت‌ها
    MISSION_POOL = {
        "m_raid": {"name": "Frontline Aggressor", "goal": 3, "type": "raids", "reward_gold": 10000, "reward_honor": 50},
        "m_gold": {"name": "Industrial Titan", "goal": 50000, "type": "gold_mined", "reward_gold": 5000, "reward_honor": 30},
        "m_sync": {"name": "Neural Harmonizer", "goal": 1, "type": "sync_ops", "reward_gold": 20000, "reward_honor": 100}
    }

    @staticmethod
    def get_daily_missions(player_data):
        # در نسخه نهایی، ماموریت‌ها بر اساس رندوم سید روزانه انتخاب می‌شوند
        active = player_data.get("active_missions", ["m_raid", "m_gold", "m_sync"])
        results = []
        for mid in active:
            m = MissionsEngine.MISSION_POOL[mid]
            # در اینجا باید پیشرفت واقعی از دیتای بازیکن خوانده شود
            current_progress = 0 # Placeholder for actual counter logic
            results.append({
                "id": mid,
                "name": m["name"],
                "progress": current_progress,
                "goal": m["goal"],
                "reward_gold": m["reward_gold"],
                "reward_honor": m["reward_honor"],
                "is_claimed": mid in player_data.get("claimed_daily_missions", [])
            })
        return results

    @staticmethod
    def claim_mission(player_data, mission_id):
        if mission_id in player_data.get("claimed_daily_missions", []):
            return False, "Mission rewards already claimed."
        
        # تایید تکمیل ماموریت (در اینجا ساده سازی شده)
        m = MissionsEngine.MISSION_POOL.get(mission_id)
        player_data["gold"] += m["reward_gold"]
        player_data["power_score"] = player_data.get("power_score", 0) + m["reward_honor"]
        
        claimed = player_data.get("claimed_daily_missions", [])
        claimed.append(mission_id)
        player_data["claimed_daily_missions"] = claimed
        
        return True, f"Objective {m['name']} neutralized. Rewards deployed."
