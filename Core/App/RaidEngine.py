import time
import random

class RaidEngine:
    SHIELD_DURATION_HOURS = 12
    LOOT_PERCENTAGE = 0.20

    @staticmethod
    def initiate_raid(attacker_data: dict, defender_data: dict) -> dict:
        shield_expiry = defender_data.get('shield_active_until', 0)
        if time.time() < shield_expiry:
            return {'success': False, 'result': 'Defended', 'message': 'Target Firewall (Shield) is ACTIVE. Raid blocked.'}

        attacker_troops = attacker_data.get('troops', 0)
        if attacker_troops <= 0:
            return {'success': False, 'result': 'Failed', 'message': 'No troops available to initiate raid.'}

        attacker_power = attacker_troops * random.uniform(1.5, 2.5)
        defender_power = defender_data.get('town_hall_level', 1) * 10 * random.uniform(1.0, 2.0)

        if attacker_power > defender_power:
            loot_gold = int(defender_data.get('gold', 0) * RaidEngine.LOOT_PERCENTAGE)
            loot_gems = int(defender_data.get('gems', 0) * RaidEngine.LOOT_PERCENTAGE)
            return {'success': True, 'result': 'Victory', 'loot_gold': loot_gold, 'loot_gems': loot_gems, 'troops_lost': random.randint(1, max(1, int(attacker_troops * 0.2))), 'message': f'Raid Successful! Looted {loot_gold} Gold and {loot_gems} Gems.'}
        else:
            return {'success': True, 'result': 'Defeat', 'loot_gold': 0, 'loot_gems': 0, 'troops_lost': random.randint(1, max(1, int(attacker_troops * 0.5))), 'message': 'Raid Failed. Target defenses were too strong.'}

    @staticmethod
    def activate_shield(player_data: dict) -> dict:
        cost = 10
        if player_data.get('nsm_hard', 0) < cost:
            return {'success': False, 'message': 'Insufficient NSM_Hard (10 required)'}
        expiry_time = time.time() + (RaidEngine.SHIELD_DURATION_HOURS * 3600)
        return {'success': True, 'new_nsm_hard': player_data.get('nsm_hard', 0) - cost, 'shield_expiry': expiry_time, 'message': 'Firewall activated'}
