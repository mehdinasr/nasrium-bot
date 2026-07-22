class PrestigeEngine:
    @staticmethod
    def calculate_loyalty_multiplier(player_data):
        # ۱. محاسبه قدمت و تداوم (ساده سازی شده)
        streak = player_data.get("daily_streak", 0)
        artifacts_v2 = len([a for a in player_data.get("artifacts", []) if "_v2" in a])
        total_honor = player_data.get("honor_score", 0)

        # ۲. تعیین سطح نود (Node Tier)
        multiplier = 1.0
        tier = "BRONZE"
        
        if streak >= 7 and artifacts_v2 >= 1:
            multiplier = 1.2
            tier = "SILVER"
        if streak >= 14 and artifacts_v2 >= 3:
            multiplier = 1.5
            tier = "GOLD"
        if streak >= 25 and artifacts_v2 >= 5:
            multiplier = 2.0
            tier = "IMPERIAL"
            
        return {
            "tier": tier,
            "multiplier": multiplier,
            "bonus_shards": int(player_data.get("nsm_shards", 0) * (multiplier - 1))
        }
