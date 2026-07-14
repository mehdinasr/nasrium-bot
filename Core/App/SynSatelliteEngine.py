class SynSatelliteEngine:
    # هدف نهایی برای تکمیل آرایه ماهواره ای
    SATELLITE_GOAL = {
        "gold": 500000,
        "nsm": 10000,
        "scraps": 500
    }

    @staticmethod
    def get_construction_progress(syn_data):
        current = syn_data.get("satellite_resources", {"gold": 0, "nsm": 0, "scraps": 0})
        
        # محاسبه درصد پیشرفت کل
        p_gold = (current["gold"] / SynSatelliteEngine.SATELLITE_GOAL["gold"]) * 100
        p_nsm = (current["nsm"] / SynSatelliteEngine.SATELLITE_GOAL["nsm"]) * 100
        p_scraps = (current["scraps"] / SynSatelliteEngine.SATELLITE_GOAL["scraps"]) * 100
        
        total_progress = (p_gold + p_nsm + p_scraps) / 3
        return round(min(100, total_progress), 2), current

    @staticmethod
    def add_resource(player_data, res_type, amount):
        syn_data = player_data.get("syndicate_data", {})
        resources = syn_data.get("satellite_resources", {"gold": 0, "nsm": 0, "scraps": 0})
        
        if player_data.get(res_type, 0) < amount:
            return False, "Insufficient player resources."
            
        # کسر از بازیکن و اضافه به مخزن سندیکا
        player_data[res_type] -= amount
        resources[res_type] += amount
        syn_data["satellite_resources"] = resources
        player_data["syndicate_data"] = syn_data
        
        return True, f"Contribution successful. Satellite Array updated."
