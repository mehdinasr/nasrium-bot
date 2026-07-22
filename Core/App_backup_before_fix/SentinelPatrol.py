import time
import random

class SentinelPatrol:
    @staticmethod
    def get_defense_bonus(player_data):
        # بررسی اینکه آیا پهپادها فعال هستند (دارای سوخت انرژی)
        drones_active = player_data.get("drones_active_until", 0)
        if time.time() > drones_active:
            return 0
        
        # قدرت دفاعی پایه پهپادها
        base_bonus = 50 
        # تاثیر مهارت معماری یا استراتژیست بر قدرت پهپاد
        unlocked = player_data.get("unlocked_skills", [])
        if "tactician" in unlocked:
            base_bonus += 25
            
        return base_bonus

    @staticmethod
    def activate_drones(player_data):
        # فعال سازی پهپادها برای ۴ ساعت با مصرف ۱۵ انرژی
        from Core.App.EnergyEngine import EnergyEngine
        success, player_data = EnergyEngine.consume_energy(player_data, 15)
        if success:
            player_data["drones_active_until"] = time.time() + 14400
            return True, "Sentinel Drones deployed for 4 hours."
        return False, "Not enough Energy to launch drones."
