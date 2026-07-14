import os

print('[STEP 1] Upgrading GameConfigEngine with Cache Clear...')
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
"""
os.makedirs('Core/App', exist_ok=True)
with open('Core/App/GameConfigEngine.py', 'w', encoding='utf-8') as f: f.write(config_engine_code)
print('[OK] GameConfigEngine updated with reload method')

print('[STEP 2] Upgrading MissionEngine with Dynamic Config...')
mission_code = """import time
from Core.App.GameConfigEngine import GameConfigEngine

class MissionEngine:
    @staticmethod
    def claim_daily(player_data: dict) -> dict:
        config = GameConfigEngine.load_config()
        eco_cfg = config.get('economy', {})
        
        daily_rewards = {
            "gold": eco_cfg.get('daily_reward_gold', 5000),
            "nsm_soft": eco_cfg.get('daily_reward_nsm_soft', 50),
            "troops": eco_cfg.get('daily_reward_troops', 2)
        }
        cooldown_seconds = 86400

        last_claim = player_data.get("last_daily_claim", 0)
        current_time = time.time()
        
        if current_time - last_claim < cooldown_seconds:
            remaining_hrs = int((cooldown_seconds - (current_time - last_claim)) / 3600)
            return {'success': False, 'message': f'Daily reward already claimed. Come back in {remaining_hrs} hours.'}
        
        return {
            'success': True,
            'rewards': daily_rewards,
            'new_claim_time': current_time,
            'message': f'Daily Reward Claimed! +{daily_rewards["gold"]} Gold, +{daily_rewards["nsm_soft"]} NSM_Soft, +{daily_rewards["troops"]} Troops'
        }
"""
with open('Core/App/MissionEngine.py', 'w', encoding='utf-8') as f: f.write(mission_code)
print('[OK] MissionEngine updated')

print('[STEP 3] Patching mini_api.py with Admin Reload API...')
api_file = 'mini_api.py'
if os.path.exists(api_file):
    with open(api_file, 'r', encoding='utf-8') as f: content = f.read()

    if '/api/admin/reload_config' not in content:
        reload_api = '''
@app.route('/api/admin/reload_config', methods=['POST'])
def admin_reload_config():
    try:
        data = request.json; key = data.get('admin_key')
        if not AdminEngine.verify_commander(key): return jsonify({'error': 'Unauthorized'}), 403
        
        new_config = GameConfigEngine.reload_config()
        return jsonify({'success': True, 'message': 'Game balance reloaded from JSON without restart!', 'current_config': new_config})
    except Exception as e: return jsonify({'error': str(e)}), 500
'''
        if 'app.run(host=' in content: content = content.replace('app.run(host=', reload_api + '\napp.run(host=', 1)

    with open(api_file, 'w', encoding='utf-8') as f: f.write(content)
    print('[OK] Admin Reload API injected')

print('[STEP 4] Committing and pushing...')
