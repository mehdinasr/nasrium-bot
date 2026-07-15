class SeasonManager:
    """ID_1002: مدیریت فصول امپراتوری."""
    CURRENT_SEASON = "SEASON_ZERO"
    GENESIS_BONUS_POOL = 10**8 # ۱۰۰ میلیون IXP برای پیشگامان
    
    @staticmethod
    def apply_season_buffs(player_data):
        # بوف ۵۰٪ سرعت استخراج برای هفته‌ی اولِ افتتاحیه
        player_data["mining_boost"] = player_data.get("mining_boost", 1.0) + 0.5
        return True
