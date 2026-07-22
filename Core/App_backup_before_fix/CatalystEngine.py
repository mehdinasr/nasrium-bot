import time

class CatalystEngine:
    # تعریف دستورالعمل‌ها و پاداش‌ها
    CATALYSTS = {
        "overclock": {"name": "Neural Overclock", "gold_cost": 5000, "scrap_cost": 20, "duration": 3600},
        "nano_fix": {"name": "Nano-Repair Kit", "gold_cost": 3000, "scrap_cost": 50, "effect": "repair_20"},
        "titan": {"name": "Titan-Serum", "gold_cost": 8000, "scrap_cost": 40, "bonus": "ATK +10%"}
    }

    @staticmethod
    def craft(player_data, catalyst_id):
        cat = CatalystEngine.CATALYSTS.get(catalyst_id)
        if not cat: return False, "Invalid Catalyst ID."

        if player_data.get("gold", 0) < cat["gold_cost"] or player_data.get("scraps", 0) < cat["scrap_cost"]:
            return False, "Insufficient resources for synthesis."

        player_data["gold"] -= cat["gold_cost"]
        player_data["scraps"] -= cat["scrap_cost"]
        
        inventory = player_data.get("consumables", {})
        inventory[catalyst_id] = inventory.get(catalyst_id, 0) + 1
        player_data["consumables"] = inventory
        
        return True, f"Synthesis Complete: {cat['name']} added to field kit."

    @staticmethod
    def use(player_data, catalyst_id):
        inventory = player_data.get("consumables", {})
        if inventory.get(catalyst_id, 0) <= 0:
            return False, "You do not have this catalyst in reserve."

        inventory[catalyst_id] -= 1
        player_data["consumables"] = inventory
        
        # اعمال اثر (منطق زمانی در گام‌های بعد تکمیل می‌شود)
        return True, f"Catalyst {catalyst_id} injected. Tactical advantage active."
