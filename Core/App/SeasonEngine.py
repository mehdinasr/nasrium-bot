import time

class SeasonEngine:
    # تعریف فصل‌های برنامه‌ریزی شده
    SEASON_DATA = {
        "S1": {"name": "Alpha Genesis", "rule": "+50% Raid Loot", "bonus_type": "loot", "end_date": 1723000000},
        "S2": {"name": "Neon Uprising", "rule": "-30% Research Cost", "bonus_type": "research", "end_date": 1725600000}
    }
    CURRENT_SEASON = "S1"

    @staticmethod
    def get_season_status():
        s = SeasonEngine.SEASON_DATA[SeasonEngine.CURRENT_SEASON]
        remaining = int(s["end_date"] - time.time())
        return {
            "id": SeasonEngine.CURRENT_SEASON,
            "name": s["name"],
            "rule": s["rule"],
            "days_left": max(0, remaining // 86400)
        }

    @staticmethod
    def calculate_season_points(player_data):
        # امتیاز فصلی = (نبردها * ۱۰) + (ارتقاها * ۵۰) + (استیکینگ / ۱۰۰)
        raids = player_data.get("raid_wins", 0)
        upgrades = player_data.get("town_hall_level", 1) * 5
        staking = player_data.get("vault", {}).get("staked", 0) / 100
        
        return int((raids * 10) + upgrades + staking)
