import random

class ArenaEngine:
    # تعریف سطوح لیگ و آستانه امتیاز
    TIERS = {
        "Apprentice": 0,
        "Knight": 1000,
        "Lord": 2500,
        "Grandmaster": 5000,
        "Sovereign": 10000
    }

    @staticmethod
    def calculate_hero_cp(player_data):
        # محاسبه قدرت نبرد (CP) قهرمان بر اساس لول، تجهیزات و بوف‌های موزه
        lvl = player_data.get("hero_level", 1)
        base_cp = lvl * 150
        # اضافه کردن تاثیر لول آکادمی (گام ۴۶۹)
        academy_bonus = sum(player_data.get("troop_levels", {}).values()) * 10
        return base_cp + academy_bonus

    @staticmethod
    def resolve_duel(attacker_data, defender_data):
        att_cp = ArenaEngine.calculate_hero_cp(attacker_data)
        def_cp = ArenaEngine.calculate_hero_cp(defender_data)
        
        # شبیه‌سازی با واریانس ۱۵٪ برای شانس و استراتژی
        att_score = att_cp * random.uniform(0.85, 1.15)
        def_score = def_cp * random.uniform(0.85, 1.15)
        
        if att_score > def_score:
            points = 25 # امتیاز مثبت برای برنده
            return True, f"Victory! Your Hero dominated the Arena. +{points} Rank Points.", points
        else:
            points = -15 # کسر امتیاز برای بازنده
            return False, f"Defeat! The opponent's strategy was superior. {points} Rank Points.", points
