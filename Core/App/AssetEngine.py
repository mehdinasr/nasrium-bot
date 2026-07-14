from Core.App.HeroEngine import HeroEngine
from Core.App.ItemEngine import ItemEngine
﻿class AssetEngine:
    @staticmethod
    def calculate_stats(player_data):
        # فرمول قدرت حمله: هر سرباز 10 واحد قدرت + 5% ضریب به ازای هر لول نکسوس
        troops = player_data.get('troops', 0)
        level = player_data.get('town_hall_level', 1)
        
        base_atk = troops * 10
        h_stats = HeroEngine.get_hero_stats(player_data)
        atk_multiplier = 1 + (level * 0.05) + (h_stats['leadership'] / 100)
        total_atk = ItemEngine.calculate_boosted_value(int(base_atk * atk_multiplier), player_data, 'atk')
        
        # قدرت دفاعی: سطح نکسوس نقش اساسی دارد
        total_def = ItemEngine.calculate_boosted_value(int((level * 100) + (troops * 5)), player_data, 'def')
        
        return {
            "attack_power": total_atk,
            "defense_power": total_def,
            "army_readiness": "High" if troops > 10 else "Low"
        }
