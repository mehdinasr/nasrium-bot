from Core.App.SubscriptionEngine import SubscriptionEngine
import time

class EnergyEngine:
    MAX_ENERGY = 100
    RECOVERY_RATE_PER_HOUR = 10 # ۱۰ واحد در ساعت

    @staticmethod
    def sync_energy(player_data):
        current_time = time.time()
        last_update = player_data.get("last_energy_update", current_time)
        current_energy = player_data.get("energy", EnergyEngine.MAX_ENERGY)

        # محاسبه مقدار انری بازیابی شده
        elapsed_hours = (current_time - last_update) / 3600
        recovered = int(elapsed_hours * EnergyEngine.RECOVERY_RATE_PER_HOUR * (5 if SubscriptionEngine.is_boost_active(player_data, 'energy_surge') else 1))

        if recovered > 0:
            player_data["energy"] = min(EnergyEngine.MAX_ENERGY, current_energy + recovered)
            player_data["last_energy_update"] = current_time
        
        return player_data

    @staticmethod
    def consume_energy(player_data, amount):
        player_data = EnergyEngine.sync_energy(player_data)
        if player_data["energy"] >= amount:
            player_data["energy"] -= amount
            return True, player_data
        return False, player_data
