class HeroEngine:
    @staticmethod
    def get_hero_stats(player_data):
        # سطح قهرمان بر اساس لول نکسوس و XP محاسبه می‌شود
        hero_level = player_data.get('town_hall_level', 1)
        
        # صفات به صورت داینامیک بر اساس لول محاسبه می‌شوند
        stats = {
            "leadership": 10 + (hero_level * 5),  # هر لول +5 قدرت رهبری
            "intelligence": 5 + (hero_level * 2),  # کاهش زمان ساخت
            "luck": hero_level * 1.5              # شانس غارت بیشتر
        }
        return stats

    @staticmethod
    def apply_hero_buffs(base_value, stat_value, buff_type):
        if buff_type == "military":
            return int(base_value * (1 + (stat_value / 100)))
        if buff_type == "economy":
            return int(base_value * (1 + (stat_value / 50)))
        return base_value
