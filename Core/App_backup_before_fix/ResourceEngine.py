import time
from Core.App.GameConfigEngine import GameConfigEngine

class ResourceEngine:
    @staticmethod
    def calculate_collection(player_data: dict) -> dict:
        config = GameConfigEngine.load_config()
        build_cfg = config.get('buildings', {})
        
        prod_rates = {"gold_mine": build_cfg.get('gold_mine_production_rate', 10), "gem_drill": build_cfg.get('gem_drill_production_rate', 1)}
        max_hours = build_cfg.get('max_storage_hours', 8)

        last_collect = player_data.get("last_collect_time", time.time())
        current_time = time.time()
        elapsed_minutes = (current_time - last_collect) / 60
        max_minutes = max_hours * 60
        elapsed_minutes = min(elapsed_minutes, max_minutes)

        buildings = player_data.get("buildings", {"gold_mine": 0, "gem_drill": 0})
        gold_mine_lvl = buildings.get("gold_mine", 0)
        gem_drill_lvl = buildings.get("gem_drill", 0)

        speed_multiplier = player_data.get("speed_multiplier", 1.0)

        earned_gold = int(elapsed_minutes * gold_mine_lvl * prod_rates["gold_mine"] * speed_multiplier)
        earned_gems = int(elapsed_minutes * gem_drill_lvl * prod_rates["gem_drill"] * speed_multiplier)

        return {
            "earned_gold": earned_gold, "earned_gems": earned_gems,
            "new_gold": player_data.get("gold", 0) + earned_gold,
            "new_gems": player_data.get("gems", 0) + earned_gems,
            "new_collect_time": current_time, "multiplier_used": speed_multiplier
        }
