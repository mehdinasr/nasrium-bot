import os

print('[STEP 1] Upgrading ResourceEngine with Dynamic Config...')
resource_code = """import time
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
"""
os.makedirs('Core/App', exist_ok=True)
with open('Core/App/ResourceEngine.py', 'w', encoding='utf-8') as f: f.write(resource_code)
print('[OK] ResourceEngine updated')

print('[STEP 2] Upgrading TransferEngine with Dynamic Config...')
transfer_code = """from Core.App.GameConfigEngine import GameConfigEngine

class TransferEngine:
    @staticmethod
    def initiate_transfer(sender_data: dict, receiver_id: int, currency: str, amount: float) -> dict:
        config = GameConfigEngine.load_config()
        eco_cfg = config.get('economy', {})
        transfer_fee = eco_cfg.get('transfer_fee_ton', 0.05)

        if currency not in ['nsm_soft', 'nsm_hard']:
            return {'success': False, 'message': 'Invalid currency'}
        if amount <= 0:
            return {'success': False, 'message': 'Amount must be greater than zero'}
        if sender_data.get('user_id') == receiver_id:
            return {'success': False, 'message': 'Cannot transfer to yourself'}

        sender_balance = sender_data.get(currency, 0)
        if sender_balance < amount:
            return {'success': False, 'message': f'Insufficient {currency} balance'}

        sender_ton = sender_data.get('ton_balance', 0)
        if sender_ton < transfer_fee:
            return {'success': False, 'message': f'Insufficient TON balance for fee ({transfer_fee} TON required)'}

        return {
            'success': True, 'sender_id': sender_data['user_id'], 'receiver_id': receiver_id,
            'currency': currency, 'amount': amount, 'fee_ton': transfer_fee,
            'message': f'Transfer of {amount} {currency} initiated. Fee: {transfer_fee} TON.'
        }
"""
with open('Core/App/TransferEngine.py', 'w', encoding='utf-8') as f: f.write(transfer_code)
print('[OK] TransferEngine updated')

print('[STEP 3] Upgrading RaidEngine with Dynamic Config...')
raid_code = """import time
import random
from Core.App.GameConfigEngine import GameConfigEngine

class RaidEngine:
    @staticmethod
    def initiate_raid(attacker_data: dict, defender_data: dict) -> dict:
        config = GameConfigEngine.load_config()
        combat_cfg = config.get('combat', {})
        loot_pct = combat_cfg.get('loot_percentage', 0.20)

        shield_expiry = defender_data.get('shield_active_until', 0)
        if time.time() < shield_expiry:
            return {'success': False, 'result': 'Defended', 'message': 'Target Firewall (Shield) is ACTIVE.'}

        attacker_troops = attacker_data.get('troops', 0)
        if attacker_troops <= 0:
            return {'success': False, 'result': 'Failed', 'message': 'No troops available.'}

        attacker_power = attacker_troops * random.uniform(1.5, 2.5)
        defender_power = defender_data.get('town_hall_level', 1) * 10 * random.uniform(1.0, 2.0)

        if attacker_power > defender_power:
            loot_gold = int(defender_data.get('gold', 0) * loot_pct)
            loot_gems = int(defender_data.get('gems', 0) * loot_pct)
            return {'success': True, 'result': 'Victory', 'loot_gold': loot_gold, 'loot_gems': loot_gems, 'troops_lost': random.randint(1, max(1, int(attacker_troops * 0.2))), 'message': f'Raid Successful! Looted {loot_gold} Gold.'}
        else:
            return {'success': True, 'result': 'Defeat', 'loot_gold': 0, 'loot_gems': 0, 'troops_lost': random.randint(1, max(1, int(attacker_troops * 0.5))), 'message': 'Raid Failed.'}

    @staticmethod
    def activate_shield(player_data: dict) -> dict:
        config = GameConfigEngine.load_config()
        combat_cfg = config.get('combat', {})
        cost = combat_cfg.get('shield_cost_nsm_hard', 10)
        duration = combat_cfg.get('shield_duration_hours', 12)
        
        if player_data.get('nsm_hard', 0) < cost:
            return {'success': False, 'message': f'Insufficient NSM_Hard ({cost} required)'}
        expiry_time = time.time() + (duration * 3600)
        return {'success': True, 'new_nsm_hard': player_data.get('nsm_hard', 0) - cost, 'shield_expiry': expiry_time, 'message': f'Shield activated for {duration} hours!'}
"""
with open('Core/App/RaidEngine.py', 'w', encoding='utf-8') as f: f.write(raid_code)
print('[OK] RaidEngine updated')

print('[STEP 4] Committing and pushing...')
