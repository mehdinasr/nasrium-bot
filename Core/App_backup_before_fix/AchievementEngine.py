class AchievementEngine:
    # تعریف دستاوردها و آستانه‌ها
    ACHIEVEMENTS = {
        "raid_10": {"name": "Novice Raider", "target": 10, "stat": "total_raids", "reward": 5000},
        "build_5": {"name": "Master Architect", "target": 5, "stat": "th_level", "reward": 10000},
        "ref_5": {"name": "Junior Envoy", "target": 5, "stat": "ref_count", "reward": 15000}
    }

    @staticmethod
    def check_achievements(player_data):
        # این متد بررسی می‌کند کدام دستاوردها تکمیل شده اما دریافت نشده‌اند
        completed = []
        claimed = player_data.get("claimed_achievements", [])
        
        # استخراج آمارهای فعلی بازیکن
        stats = {
            "total_raids": player_data.get("raid_count", 0),
            "th_level": player_data.get("town_hall_lvl", 1),
            "ref_count": len(player_data.get("recruits", []))
        }

        for ach_id, config in AchievementEngine.ACHIEVEMENTS.items():
            if ach_id not in claimed:
                if stats.get(config["stat"], 0) >= config["target"]:
                    completed.append(ach_id)
        
        return completed
