import math

class ExperienceEngine:
    BASE_XP = 100
    EXPONENT = 1.5

    @staticmethod
    def get_xp_for_level(level):
        # فرمول: لول ۱ به ۲ = ۱۰۰ واحد، لول ۲ به ۳ = ۲۸۲ واحد و ...
        if level < 1: return 0
        return int(ExperienceEngine.BASE_XP * (level ** ExperienceEngine.EXPONENT))

    @staticmethod
    def add_xp(player_data, amount):
        current_xp = player_data.get("xp", 0)
        current_lvl = player_data.get("town_hall_level", 1)
        
        new_xp = current_xp + amount
        required_xp = ExperienceEngine.get_xp_for_level(current_lvl)
        
        leveled_up = False
        if new_xp >= required_xp:
            # فعلاً لول‌آپ خودکار را فعال نمی‌کنیم تا بازیکن دکمه Upgrade را بزند، 
            # اما XP را ثبت می‌کنیم.
            pass
            
        player_data["xp"] = new_xp
        return player_data, leveled_up
