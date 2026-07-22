import time

class LunarEngine:
    # پارامترهای پایگاه ماه
    HE3_YIELD_RATE = 1.5 # واحد هلیوم-۳ در ساعت
    CONSTRUCTION_COST = {"gold": 500000, "nsm_hard": 200, "crystals": 50}

    @staticmethod
    def build_outpost(player_data):
        # بررسی پیش‌نیازها
        costs = LunarEngine.CONSTRUCTION_COST
        if player_data.get("gold", 0) < costs["gold"] or \
           player_data.get("nsm_hard", 0) < costs["nsm_hard"] or \
           player_data.get("primal_crystals", 0) < costs["crystals"]:
            return False, "Insufficient materials for Lunar Launch."

        if player_data.get("lunar_base_active", False):
            return False, "Lunar Outpost is already operational."

        # کسر منابع و فعال‌سازی
        player_data["gold"] -= costs["gold"]
        player_data["nsm_hard"] -= costs["nsm_hard"]
        player_data["primal_crystals"] -= costs["crystals"]
        
        player_data["lunar_base_active"] = True
        player_data["lunar_base_lvl"] = 1
        player_data["last_he3_claim"] = time.time()
        
        return True, "Touchdown Confirmed: Lunar Outpost Alpha is now online."

    @staticmethod
    def get_he3_status(player_data):
        if not player_data.get("lunar_base_active"): return 0
        last_claim = player_data.get("last_he3_claim", time.time())
        hours = (time.time() - last_claim) / 3600
        return int(hours * LunarEngine.HE3_YIELD_RATE * player_data.get("lunar_base_lvl", 1))
