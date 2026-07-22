from Core.App.DecreeEngine import DecreeEngine
import time
from Core.App.GameConfigEngine import GameConfigEngine

class BuildingEngine:
    @staticmethod
    def get_upgrade_details(current_level):
        config = GameConfigEngine.load_config()
        costs = config.get('upgrades', {}).get('nexus_upgrade_costs', {})
        next_level = current_level + 1
        cost = costs.get(str(next_level), costs.get(next_level, 999999))
        
        # زمان ساخت: به ازای هر لول، 5 دقیقه اضافه شود (ثانیه)
        from Core.App.PlayerRepository import PlayerRepository
        raw_time = next_level * 300
        build_time = DecreeEngine.apply_decree_bonus(PlayerRepository.get_db(), raw_time, 'build_time') 
        return cost, build_time

    @staticmethod
    def start_upgrade(player_data):
        current_level = player_data.get('town_hall_level', 1)
        cost, build_time = BuildingEngine.get_upgrade_details(current_level)
        
        if player_data.get('gold', 0) >= cost:
            player_data['gold'] -= cost
            player_data['construction_until'] = time.time() + build_time
            player_data['is_building'] = True
            return True, player_data
        return False, player_data

    @staticmethod
    def finalize_upgrade(player_data):
        # بررسی اینکه آیا زمان ساخت تمام شده یا خیر
        finish_time = player_data.get('construction_until', 0)
        if time.time() >= finish_time and player_data.get('is_building', False):
            player_data['town_hall_level'] += 1
            player_data['is_building'] = False
            player_data['construction_until'] = 0
            return True, player_data
        return False, player_data
