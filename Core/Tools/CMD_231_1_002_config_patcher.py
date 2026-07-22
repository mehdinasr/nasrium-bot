import os
import json

print('[STEP 1] Creating GameConfigEngine.py...')
config_engine_code = """import json
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
    def get_default_config() -> dict:
        # مقادیر پیشفرض بازی
        return {
            'economy': {
                'troop_train_cost_gold': 500,
                'daily_reward_gold': 5000,
                'daily_reward_nsm_soft': 50,
                'daily_reward_troops': 2,
                'transfer_fee_ton': 0.05
            },
            'combat': {
                'loot_percentage': 0.20,
                'shield_duration_hours': 12,
                'shield_cost_nsm_hard': 10
            },
            'buildings': {
                'gold_mine_production_rate': 10,
                'gem_drill_production_rate': 1,
                'max_storage_hours': 8
            },
            'upgrades': {
                'nexus_upgrade_costs': {1: 1000, 2: 5000, 3: 25000, 4: 100000, 5: 500000}
            }
        }

    @staticmethod
    def save_config(config_data: dict):
        with open(GameConfigEngine.CONFIG_PATH, 'w', encoding='utf-8') as f:
            json.dump(config_data, f, indent=4)
        GameConfigEngine._config_cache = config_data
"""
os.makedirs('Core/App', exist_ok=True)
with open('Core/App/GameConfigEngine.py', 'w', encoding='utf-8') as f: f.write(config_engine_code)
print('[OK] GameConfigEngine.py created')

print('[STEP 2] Generating default game_balance.json...')
os.makedirs('Config', exist_ok=True)
default_config = {
    "economy": {
        "troop_train_cost_gold": 500,
        "daily_reward_gold": 5000,
        "daily_reward_nsm_soft": 50,
        "daily_reward_troops": 2,
        "transfer_fee_ton": 0.05
    },
    "combat": {
        "loot_percentage": 0.20,
        "shield_duration_hours": 12,
        "shield_cost_nsm_hard": 10
    },
    "buildings": {
        "gold_mine_production_rate": 10,
        "gem_drill_production_rate": 1,
        "max_storage_hours": 8
    },
    "upgrades": {
        "nexus_upgrade_costs": {1: 1000, 2: 5000, 3: 25000, 4: 100000, 5: 500000}
    }
}
with open('Config/game_balance.json', 'w', encoding='utf-8') as f:
    json.dump(default_config, f, indent=4)
print('[OK] Config/game_balance.json created')

print('[STEP 3] Injecting Config loading into mini_api.py startup...')
api_file = 'mini_api.py'
if os.path.exists(api_file):
    with open(api_file, 'r', encoding='utf-8') as f: content = f.read()

    if 'from Core.App.GameConfigEngine import GameConfigEngine' not in content:
        content = 'from Core.App.GameConfigEngine import GameConfigEngine\n' + content

    if 'GameConfigEngine.load_config()' not in content:
        # اضافه کردن لود شدن تنظیمات هنگام شروع سرور
        startup_hook = """
# Load Game Balance Config at startup
GAME_CONFIG = GameConfigEngine.load_config()
"""
        if 'if __name__ ==' in content:
            content = content.replace('if __name__ ==', startup_hook + '\nif __name__ ==', 1)
            print('[OK] GameConfig loading injected into startup')

    with open(api_file, 'w', encoding='utf-8') as f: f.write(content)
    print('[OK] API Patched')

print('[STEP 4] Committing and pushing...')
