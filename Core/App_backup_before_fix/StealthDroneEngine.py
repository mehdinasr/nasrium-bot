class StealthDroneEngine:
    # پارامترهای پهپاد
    DRONE_COST = {"gold": 30000, "scraps": 50}
    SUCCESS_CHANCE = 0.95 # ۹۵٪ شانس عبور از رادار

    @staticmethod
    def build_drone(player_data):
        if player_data.get("gold", 0) < StealthDroneEngine.DRONE_COST["gold"] or \
           player_data.get("scraps", 0) < StealthDroneEngine.DRONE_COST["scraps"]:
            return False, "Insufficient materials for Stealth Drone assembly."

        player_data["gold"] -= StealthDroneEngine.DRONE_COST["gold"]
        player_data["scraps"] -= StealthDroneEngine.DRONE_COST["scraps"]
        
        drones = player_data.get("stealth_drones", 0)
        player_data["stealth_drones"] = drones + 1
        return True, "Stealth Drone assembled and ready for recon."

    @staticmethod
    def dispatch_recon(player_data, target_data):
        if player_data.get("stealth_drones", 0) <= 0:
            return False, "No Stealth Drones available in hangar."

        player_data["stealth_drones"] -= 1
        
        import random
        if random.random() < StealthDroneEngine.SUCCESS_CHANCE:
            # شناسایی جزئیات هدف (مثلاً لول خزانه کوانتومی)
            v_lvl = target_data.get("vault_encryption_lvl", 1)
            return True, f"Recon Complete. Target Vault Encryption: Layer {v_lvl}. Assets scanned successfully."
        else:
            return False, "Drone lost in signal interference. Mission failed."
