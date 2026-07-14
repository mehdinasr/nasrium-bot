import json
import os

class GameConfigEngine:
    CONFIG_PATH = 'Config/game_balance.json'
    _config_cache = None

    @staticmethod
    def load_config() -> dict:
        if GameConfigEngine._config_cache is not None:
            return GameConfigEngine._config_cache
            
        if not os.path.exists(GameConfigEngine.CONFIG_PATH):
            return GameConfigEngine.get_default_config()
            
        with open(GameConfigEngine.CONFIG_PATH, 'r', encoding='utf-8') as f:
            GameConfigEngine._config_cache = json.load(f)
            return GameConfigEngine._config_cache

    @staticmethod
    def reload_config() -> dict:
        GameConfigEngine._config_cache = None
        return GameConfigEngine.load_config()

    @staticmethod
    def get_default_config() -> dict:
        return {
            'economy': {'troop_train_cost_gold': 500, 'daily_reward_gold': 5000, 'daily_reward_nsm_soft': 50, 'daily_reward_troops': 2, 'transfer_fee_ton': 0.05},
            'combat': {'loot_percentage': 0.20, 'shield_duration_hours': 12, 'shield_cost_nsm_hard': 10},
            'buildings': {'gold_mine_production_rate': 10, 'gem_drill_production_rate': 1, 'max_storage_hours': 8},
            'upgrades': {'nexus_upgrade_costs': {1: 1000, 2: 5000, 3: 25000, 4: 100000, 5: 500000}}
        }

    @staticmethod
    def save_config(config_data: dict):
        with open(GameConfigEngine.CONFIG_PATH, 'w', encoding='utf-8') as f:
            json.dump(config_data, f, indent=4)
        GameConfigEngine._config_cache = config_data
