import random

class HeistEngine:
    # تعریف انواع رویکردهای عملیاتی
    MODES = {
        "stealth": {"name": "Ghost Protocol", "base_chance": 75, "gold_mult": 1.5, "xp_mult": 1.0},
        "aggressive": {"name": "Brute Force", "base_chance": 35, "gold_mult": 5.0, "xp_mult": 2.0},
        "tactical": {"name": "Neural Breach", "base_chance": 55, "gold_mult": 2.5, "xp_mult": 3.0}
    }

    @staticmethod
    def execute_operation(player_data, mode_id):
        mode = HeistEngine.MODES.get(mode_id)
        if not mode: return False, "Invalid operation mode.", None

        # تاثیر هوش و رهبری قهرمان بر شانس موفقیت
        from Core.App.HeroEngine import HeroEngine
        h_stats = HeroEngine.get_hero_stats(player_data)
        
        chance = mode["base_chance"] + (h_stats["intelligence"] / 2)
        success = random.randint(1, 100) <= chance
        
        if success:
            reward_gold = int(2000 * mode["gold_mult"])
            reward_xp = int(100 * mode["xp_mult"])
            return True, f"Operation Successful! Retrived {reward_gold} Gold.", {"gold": reward_gold, "xp": reward_xp}
        
        return False, "Operation Failed. Operatives compromised.", None
